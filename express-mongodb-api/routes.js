module.exports = app => {
  const routes = require("./controller");
  
  var router = require("express").Router();

  // Create a new User
  router.post("/sign_up", routes.signUp);

  // Lo all Tutorials
  router.post("/login", routes.login);

  // Retrieve all published Tutorials
  router.post("/save_weight", routes.addNew);

  // Retrieve a single Tutorial with id
  router.get("/get_weight_history", routes.findAll);

  // Update a Tutorial with id
  router.put("/update_weight/:id", routes.update);

  // Delete a Tutorial with id
  router.delete("/delete_weight/:id", routes.delete);

  // Create a new Tutorial

  app.use("/api/", router);
};
