import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewTask, tasks, users } from "../db/schema";
import { uuid } from "drizzle-orm/pg-core";
import { eq } from "drizzle-orm";
import { db } from "../db";

const taskRouter = Router();
//Add Task
taskRouter.post("/", auth, async (req: AuthRequest, res) => {
  try {
    req.body = { ...req.body, uid: req.user! };
    const newTask: NewTask = req.body;
    const [task] = await db.insert(tasks).values(newTask).returning();
    res.status(201).json(task);
  } catch (e) {
    res.status(500).json({ msg: e });
  }
});

//Get Users Task
taskRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    const allTask = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uid, req.user!));
    res.json(allTask);
  } catch (e) {
    res.status(500).json({ msg: e });
  }
});
//Delete User Task

taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
  try {
    const { taskId }: { taskId: string } = req.body;
    await db.delete(tasks).where(eq(tasks.id, taskId));
    res.json(true);
  } catch (e) {
    res.status(500).json({ msg: e });
  }
});
export default taskRouter;
