import express from 'express'
import authRouter from './routes/auth';

const app = express()
app.use(express.json());
app.use("/auth",authRouter);
app.get("/",(req,res)=>{
    res.send("Welcome to my app");
})

app.listen(8000,()=>{
    console.log("server start running on prot 8000");
    console.log("server start running on prot 8000");
})
