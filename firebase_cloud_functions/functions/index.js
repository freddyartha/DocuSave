const { onSchedule } = require("firebase-functions/v2/scheduler");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const admin = require("firebase-admin");

admin.initializeApp();

exports.reminderWarranty = onSchedule(
    {
        schedule: "every day 09:00",
        timeZone: "Asia/Jakarta",
    },
    async (event) => {
        const db = getFirestore();
        const now = Timestamp.now();
        const sevenDaysLater = new Date(now.toDate().getTime() + 7 * 24 * 60 * 60 * 1000);

        const usersSnapshot = await db.collection("users").get();

        for (const user of usersSnapshot.docs) {
            const userId = user.id;
            const warrantiesRef = db.collection("users").doc(userId).collection("warranties");

            const snapshot = await warrantiesRef
                .where("warrantyExpiryDate", "<=", sevenDaysLater)
                .where("warrantyExpiryDate", ">=", now)
                .where("reminderSent", "==", false)
                .get();

            if (snapshot.empty) continue;

            // Ambil semua token notifikasi
            const tokensSnapshot = await db
                .collection("users")
                .doc(userId)
                .collection("notificationTokens")
                .get();

            const tokens = [];
            const userLanguage = user.data().selectedLanguage || "id";
            tokensSnapshot.forEach(doc => {
                const token = doc.data().notificationToken;
                if (token) tokens.push(token);
            });

            if (tokens.length === 0) continue;

            for (const warrantyDoc of snapshot.docs) {
                const data = warrantyDoc.data();
                const messages = {
                    id: {
                        title: "Garansi Segera Berakhir!",
                        body: `${data.itemName} akan habis masa garansi tanggal ${data.warrantyExpiryDate.toDate().toLocaleDateString()}`,
                    },
                    en: {
                        title: "Warranty Expiring Soon!",
                        body: `${data.itemName} warranty will expire on ${data.warrantyExpiryDate.toDate().toLocaleDateString()}`,

                    }
                };
                const message = {
                    tokens: tokens,
                    notification: {
                        title: messages[userLanguage].title,
                        body: messages[userLanguage].body,
                    },
                    data: {
                        "route": "/warranty-setup"
                    },
                };

                await getMessaging().sendEachForMulticast(message);

                await warrantiesRef.doc(warrantyDoc.id).update({ reminderSent: true });
            }
        }
    }
);
