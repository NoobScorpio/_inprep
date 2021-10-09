const functions = require('firebase-functions');

const admin = require('firebase-admin');
//const nodemailer = require('nodemailer');
// const cors = require('cors')({ origin: true });
admin.initializeApp(functions.config().firebase);
// let transporter = nodemailer.createTransport({
//     service: 'gmail',W
//     auth: {
//         user: 'inprepinfo@gmail.com',
//         pass: '1n5tallm3'  //you your password
//     }
// });

exports.messageTrigger = functions.firestore.document(
    "chats/{cid}/messages/{meid}").onCreate((snapshot, context) => {
        doc = snapshot.data();
        console.log(doc);
        const idFrom = doc.sid;
        const idTo = doc.rid;
        const cid = doc.cid;
        const contentMessage = doc.message;

        admin
            .firestore()
            .collection('user')
            .where('uid', '==', idFrom)
            .get()
            .then((querySnapshot) => {
                querySnapshot.forEach(userFrom => {
                    admin
                        .firestore()
                        .collection('user')
                        .where('uid', '==', idTo)
                        .get().then(querySnapshot2 => {
                            querySnapshot2.forEach(userTo => {
                                console.log(`Found user from: ${userFrom.data().displayName}`);
                                const payloadAndroid = {
                                    notification: {
                                        title: `Message from ${userFrom.data().displayName}`,
                                        from: `${userFrom.data().displayName}`,
                                        to: `${userTo.data().displayName}`,
                                        body: contentMessage,
                                        badge: '1',
                                        sound: 'default',
                                        cid: `${cid}`,
                                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                        priority: "high"
                                    }
                                }
                                const payloadIOS = {
                                    notification: {
                                        title: `Message from ${userFrom.data().displayName}`,
                                        from: `${userFrom.data().displayName}`,
                                        to: `${userTo.data().displayName}`,
                                        body: contentMessage,
                                        badge: userTo.data().badge.toString(),
                                        sound: 'default',
                                        cid: `${cid}`,
                                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                        content_available: true.toString(),
                                    }
                                }
                                var isIos;
                                if(userTo.data().isIos==null){
                                    isIos=false;
                                }else if(userTo.data().isIos==false){
                                    isIos=false;
                                }else{
                                    isIos=true;
                                }
                                admin
                                    .messaging()
                                    .sendToDevice(userTo.data().pushToken,isIos?payloadIOS: payloadAndroid)
                                    .then(response => {
                                        console.log('Successfully sent message:', response)
                                    })
                                    .catch(error => {
                                        console.log('Error sending message:', error)
                                    });

                            })
                        });
                })
            });
        // return null;
    });
//exports.sendMail = functions.https.onRequest((req, res) => {
//            cors(req, res, () => {
//                // getting dest email by query string
//                const dest = req.query.dest;
//                const message = req.query.message;
//                const mailOptions = {
//                    from: 'InPrep <inprepinfo@gmail.com>', //
//                    to: dest,
//                    subject: 'Welcome to ABC', // email subject
//                    html: `Dear Quinton, you received support email from ${dest}, <br> ${message}`
//
//                };
//                // returning result
//                return transporter.sendMail(mailOptions, (erro, info) => {
//                    if (erro) {
//                        return res.send(erro.toString());
//                    }
//                    return res.send('Sended');
//                });
//            });
//        });