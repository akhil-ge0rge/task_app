import express from "express";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";

const app = express();
app.use(express.json());
app.use("/auth", authRouter);
app.use("/task", taskRouter);
app.get("/", (req, res) => {
  res.send("Welcome to my app");
});

app.listen(8000, () => {
  console.log("server start running on prot 8000");
  console.log("server start running on prot 8000");
});
