import { Request, Router } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { error } from "console";
import { auth, AuthRequest } from "../middleware/auth";

const authRouter = Router();

interface SignUpBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

//SIGNUP
authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res) => {
  try {
    //get req body
    const { name, email, password } = req.body;
    //check user already exist
    const existingUser = await db
      .select()
      .from(users)
      .where(eq(users.email, email));
    if (existingUser.length) {
      res.status(400).json({ msg: "User with same email already exist" });
      return;
    }
    //hash password
    const hashedPassword = await bcryptjs.hash(password, 8);
    //create new user in db
    const newUser: NewUser = {
      name,
      email,
      password: hashedPassword,
    };
    const [user] = await db.insert(users).values(newUser).returning();
    res.status(201).json(user);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
//LOGIN
authRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res) => {
  try {
    //get req body
    const { email, password } = req.body;
    //check user already exist
    const [existingUser] = await db
      .select()
      .from(users)
      .where(eq(users.email, email));
    if (!existingUser) {
      res.status(400).json({ msg: "User with this email doesnt exist!" });
      return;
    }
    //hash password
    const isMatch = await bcryptjs.compare(password, existingUser.password);
    if (!isMatch) {
      res.status(400).json({ msg: "Incorrect password" });
      return;
    }
    const token = jwt.sign({ id: existingUser.id }, "passwordKey");
    res.status(200).json({ token, ...existingUser });
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

//VERIFY JWT

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    //get header
    const token = req.header("x-auth-token");
    if (!token) {
      res.json(false);
      return;
    }

    //verify token is valid
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      res.json(false);
      return;
    }

    //getUserData if token is valid
    const verifiedToken = verified as { id: string };
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.json(false);
      return;
    }

    res.json(true);
  } catch (e) {
    res.status(500).json(false);
  }
});
authRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    if (!req.user) {
      res.status(401).json({ msg: "User Not Found" });
      return;
    }
    const [user] = await db.select().from(users).where(eq(users.id, req.user));

    res.json({ ...user, token: req.token });
  } catch (e) {
    res.status(500).json(false);
  }
});

export default authRouter;
