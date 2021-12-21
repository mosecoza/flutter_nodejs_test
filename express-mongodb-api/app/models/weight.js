module.exports = mongoose => {
  var schema = mongoose.Schema(
    {
      weight: Number,
      createAt: Date,
      uid: String
    },
    { timestamps: true }
  );
 
  schema.method("toJSON", function() {
    const { __v, _id, ...object } = this.toObject();
    object.id = _id;
    return object;
  });

  const Weights = mongoose.model("weights", schema);
  return Weights;
};
