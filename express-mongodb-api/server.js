const { verifyToken } = require('./helpers');
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();

var corsOptions = {
  origin: "http://localhost:8081"
};

app.use(cors(corsOptions));
const port = "8081";
// parse requests of content-type - application/json
app.use(express.json());  /* bodyParser.json() is deprecated */

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));   /* bodyParser.urlencoded() is deprecated */
mongoose.connect(`mongodb+srv://mosecoza:moses357@cluster0.80kie.mongodb.net/weightTracker?retryWrites=true&w=majority`, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useFindAndModify: false
})

let db = mongoose.connection

db.once('open', () => {
 
  app.use(cors())
  app.use(bodyParser.json({ limit: '200mb' }));
  app.use(bodyParser.urlencoded({ limit: '200mb', extended: true }));
  app.use(bodyParser.text({ limit: '200mb' }));


  app.use('/', (req, res, next) => {
    const allowed = ['/login', '/sign_up']
    let isAllowed = false
    for (const pathUri of allowed) {
      if (req.url.indexOf(pathUri) !== -1) {
        isAllowed = true
      }
    }
    if (isAllowed) {
      console.log(req.body);
      next()
    } else {
      const token = req.headers['x-token']

      const result = verifyToken("" + token)
      if (result) {

        next()
      } else res.status(401).send("Invalid Credentials");
    }
  })

  app.get("/", (_, res) => {
    res.send("Server is running :)");
  });
  require("./routes")(app);


  app.listen(port, () => {
    console.log(`server started at http://localhost:${port}`);
  });
})