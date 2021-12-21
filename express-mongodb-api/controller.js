const { generateToken, verifyToken } = require('./helpers');
const db = require("./app/models/index");
const crypto = require('crypto');
const Users = db.users;
const Weights = db.weight;

// Create and Save a new Weight
exports.addNew = (req, res) => {

  const { weight } = req.body;
  // Validate request
  const token = req.headers['x-token']
  const user = verifyToken(token);

  if (user) {
    const val = user.valueOf("uid")
    // Create a Weight
    return Weights.create({
      weight: weight,
      uid: val.uid,
      createdAt: new Date(),
    }).then(doc => res.send(doc)
    )
    return;
  } else {
    res.status(401).send("Not Authorised");
  }


}

// Create and Save a new User
exports.signUp = (req, res) => {
  const { email, password, name } = req.body
  const pepper = process.env.SERVER_PORT
  console.log(req.body);
  return Users.findOne({ email }).then((user) => {

    if (user) {
      return generateToken(user.id).then(tokenResult => res.send({
        token: tokenResult,
        uid: user.id,
        name,
        email,

      })).catch(e => {
        res.status(500).send({ success: false, message: e.message })
      })

    } else {
      const salt = crypto.randomBytes(16).toString('hex');
      const hash = crypto.pbkdf2Sync(password, salt + pepper, 100000, 64, 'SHA512').toString('hex')
      return Users.create({
        email: email,
        name: name,
        password: hash,
        salt: salt,
        createdAt: new Date(),
      }).then(doc => {
        return generateToken(doc.id).then(tokenResult => res.send({
          token: tokenResult,
          uid: doc.id,
          doc

        })).catch(e => {
          res.status(500).send({ success: false, message: e.message })
        })

      }).catch(e => {
        res.status(500).send({ success: false, message: e.message })
      })

    }
  }).catch(err => {
    res.status(401)
    res.send(err)
  })
};

// log a user in
exports.login = (req, res) => {
  const { email, password } = req.body
  const pepper = process.env.SERVER_PORT


  return Users.findOne({ email }).then((user) => {
    if (user) {
      const hash = crypto.pbkdf2Sync(password, user.salt + pepper, 100000, 64, 'SHA512').toString('hex')
      return Users.findOne({ password: hash }).then((result) => {
        if (result) {
          console.log(result);
          return generateToken(result._id).then((token) => {

            res.send({
              token: token,
              email: email,

              uid: result._id,
              name: result.name
            })
          })

        } else {
          throw { message: "Wrong username or password", code: 401 }
        }
      }).catch(e => {
        res.send(e)

      })
    } else {
      throw { message: "Wrong username or password user not found", code: 401 }
    }
  }).catch(err => {
    res.status(401)
    res.send(err)
  })
};

// Retrieve all Weights from the database.
exports.findAll = (req, res) => {

  const token = req.headers['x-token']
  const user = verifyToken(token);

  if (user) {
    const val = user.valueOf("uid")
    const title = req.query.title;
    var condition = title ? { title: { $regex: new RegExp(title), $options: "i" } } : {};

    Weights.find({uid: val.uid})
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving Weights."
        });
      });
  } else{
    res.status(401).send("Not Authorised");
  }
};



// Update a Weight by the id in the request
exports.update = (req, res) => {
  if (!req.body) {
    return res.status(400).send({
      message: "Data to update can not be empty!"
    });
  }

  const id = req.params.id;

  Weights.findByIdAndUpdate(id, req.body, { useFindAndModify: false })
    .then(data => {
      if (!data) {
        res.status(404).send({
          message: `Cannot update Weight with id=${id}. Maybe Weight was not found!`
        });
      } else res.send({ message: "Weight was updated successfully." });
    })
    .catch(err => {
      res.status(500).send({
        message: "Error updating Weight with id=" + id
      });
    });
};

// Delete a Weight with the specified id in the request
exports.delete = (req, res) => {
  const id = req.params.id;

  Weights.findByIdAndRemove(id, { useFindAndModify: false })
    .then(data => {
      if (!data) {
        res.status(404).send({
          message: `Cannot delete Weight with id=${id}. Maybe Weight was not found!`
        });
      } else {
        res.send({
          message: "Weight was deleted successfully!"
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Could not delete Weight with id=" + id
      });
    });
};

// Delete all Weights from the database.
exports.deleteAll = (req, res) => {
  Weights.deleteMany({})
    .then(data => {
      res.send({
        message: `${data.deletedCount} Weights were deleted successfully!`
      });
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while removing all Weights."
      });
    });
};

