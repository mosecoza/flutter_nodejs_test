const jwt = require('jsonwebtoken');

module.exports = {
    generateToken: async (uid) => jwt.sign({
        uid,
    }, 'sdjfew0ew9kdewoijdewijkoiew98e0kewkmewouew', {
        expiresIn: 60 * 60 // Expires in an hour
    }),
    verifyToken: (token) => {
        try {
            return jwt.verify(token, 'sdjfew0ew9kdewoijdewijkoiew98e0kewkmewouew')
        } catch (err) {
            return null
        }
    },
};
