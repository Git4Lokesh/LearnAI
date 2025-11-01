import axios from "axios";
import { spawn } from "child_process";
import path from "path";
import { fileURLToPath } from "url";

const DEFAULT_BASE_URL = process.env.BKT_BASE_URL || "http://127.0.0.1:8000";

async function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function isHealthy(baseUrl = DEFAULT_BASE_URL, timeoutMs = 1000) {
  try {
    await axios.get(`${baseUrl}/health`, { timeout: timeoutMs });
    return true;
  } catch {
    return false;
  }
}

function runCommand(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: options.stdio || "ignore",
      shell: options.shell ?? true, // ensure Windows compatibility
      cwd: options.cwd || process.cwd(),
      env: options.env || process.env,
    });
    child.on("error", reject);
    child.on("exit", (code) => {
      if (code === 0) resolve();
      else reject(new Error(`${command} exited with code ${code}`));
    });
  });
}

async function tryCommands(commands) {
  for (const { cmd, args, options } of commands) {
    try {
      await runCommand(cmd, args, options);
      return { cmd, args, options };
    } catch (_) {
      // try next
    }
  }
  throw new Error("All command variants failed");
}

async function findPython(projectRoot) {
  // Try common python launchers in order
  const candidates = [
    { cmd: "python", args: ["--version"], options: { cwd: projectRoot } },
    { cmd: "py", args: ["--version"], options: { cwd: projectRoot } },
    { cmd: "python3", args: ["--version"], options: { cwd: projectRoot } },
  ];
  for (const c of candidates) {
    try {
      await runCommand(c.cmd, c.args, c.options);
      return c.cmd;
    } catch (_) { /* continue */ }
  }
  throw new Error("Python not found. Install Python 3 and add it to PATH.");
}

async function installRequirements() {
  const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
  const bktDir = path.join(projectRoot, "bkt_service");
  const reqFile = path.join(bktDir, "requirements.txt");
  const pythonExe = await findPython(projectRoot);
  // Try requirements first
  try {
    await runCommand(pythonExe, ["-m", "pip", "install", "--disable-pip-version-check", "-r", reqFile], { cwd: projectRoot });
    return pythonExe;
  } catch (e) {
    // Fallback: install essentials directly
    try {
      await runCommand(pythonExe, ["-m", "pip", "install", "--disable-pip-version-check", "fastapi", "uvicorn", "pydantic", "numpy"], { cwd: projectRoot });
      return pythonExe;
    } catch (e2) {
      throw new Error(`pip install failed: ${e2.message || e2}`);
    }
  }
}

async function startUvicorn() {
  const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
  const pythonExe = await findPython(projectRoot);
  // Run uvicorn using module path so it can import bkt_service.main
  const args = [
    "-m",
    "uvicorn",
    "bkt_service.main:app",
    "--host",
    "127.0.0.1",
    "--port",
    "8000",
  ];
  // Detached background process
  const child = spawn(pythonExe, args, {
    cwd: projectRoot,
    detached: true,
    stdio: "ignore",
    shell: true,
  });
  child.unref();
}

export async function ensureBktService(baseUrl = DEFAULT_BASE_URL) {
  // If already healthy, nothing to do
  if (await isHealthy(baseUrl, 800)) return;

  try {
    await installRequirements();
  } catch (e) {
    // If pip install fails, still attempt to start; FastAPI may already be installed globally
    // eslint-disable-next-line no-console
    console.warn("BKT: pip install failed or unavailable:", e.message || e);
  }

  try {
    await startUvicorn();
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error("BKT: failed to spawn uvicorn:", e.message || e);
    return; // Don't block Node startup
  }

  // Wait up to ~10s for health
  for (let i = 0; i < 20; i++) {
    if (await isHealthy(baseUrl, 800)) return;
    await wait(500);
  }
  // eslint-disable-next-line no-console
  console.warn("BKT: service did not become healthy in time; Node will continue.");
}
