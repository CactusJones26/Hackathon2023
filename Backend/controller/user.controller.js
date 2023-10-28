import express from "express";
import User from "../database/models/user.model.js";

const userController = express.Router();

/**
 * GET/
 * check if authenticated
 */
userController.get('/is-authenticated', (req, res) => {
    User
      .find({username: req.query.username})
      .then((data) => {
        if(data === null) {
            res.status(400).send(false);
        }
        res.status(200).send(data[0].loggedIn);
      })
      .catch((err) => {
        res.status(400).send(false);
      });
  });

  /**
 * POST/
 * login, checking username and password
 */
userController.post('/login', (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    User.find({username: username})
        .then((data) => {
            if(data[0] === null) {
                res.status(400).send(false);
            } else if(password !== data[0].password) {
                res.status(404).send(false);
            } else {
                User.updateOne({username: data[0].username}, {$set: { "loggedIn": true }})
                .catch(() => {res.status(400).send(false);});
                res.status(200).send(true);
            }
        })
        .catch(() => {res.status(400).send(false);});
  });

    /**
 * POST/
 * logout
 */
userController.post('/logout', (req, res) => {
    User
      .find({username: req.body.username})
      .then((data) => {
        User.updateOne({username: data[0].username}, {$set: { "loggedIn": false }})
            .catch((err) => {console.log(err)})
        res.status(200).send(true);
      })
      .catch(() => {
        res.status(400).send(false);
      });
  });

/**
 * POST/
 * create user
 */
userController.post('/create-user', (req, res) => {
    const newUser = new User(req.body);
    newUser
        .save()
        .then(() => {
        res.status(200).send(true);
        })
        .catch((err) => {
        res.status(400).send(err);
    });
});

/**
 * POST/
 * update profile
 */
userController.post('/update-profile', (req, res) => {
    User
      .find({username: req.body.username})
      .then((data) => {
        User.updateOne({username: data[0].username}, {$set: { "username": req.body.newUsername, "email": req.body.newEmail }})
            .catch((err) => {console.log(err)})
        res.status(200).send(true);
      })
      .catch(() => {
        res.status(400).send(false);
      });
});

/**
 * POST/
 * update-password
 */
userController.post('/create-user', (req, res) => {
    User
      .find({username: req.body.username})
      .then((data) => {
        User.updateOne({username: data[0].username}, {$set: { "password": req.body.password }})
            .catch((err) => {console.log(err)})
        res.status(200).send(true);
      })
      .catch(() => {
        res.status(400).send(false);
      });
});

export default userController;