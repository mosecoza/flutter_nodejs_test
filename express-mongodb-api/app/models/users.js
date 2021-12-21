module.exports = mongoose => {
    var schema = mongoose.Schema(
      {
        salt: String,
        password: String,
        name: String,
        email: String,
        createAt: Date,
      },
      { timestamps: true }
    );
   
    schema.method("toJSON", function() {
      const { __v, _id, ...object } = this.toObject();
      object.id = _id;
      return object;
    });
  
    const Users = mongoose.model("users", schema);
    return Users;
  };
  