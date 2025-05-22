import express from 'express';
import axios from 'axios';

const app = express();
app.use(express.json());

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const REPO_OWNER = 'Boomchainlab';
const REPO_NAME = 'slerf';
const API_BASE = 'https://api.github.com';

async function triggerWorkflow(workflowFile, ref = 'main', inputs = {}) {
  const url = `${API_BASE}/repos/${REPO_OWNER}/${REPO_NAME}/actions/workflows/${workflowFile}/dispatches`;
  try {
    await axios.post(
      url,
      { ref, inputs },
      {
        headers: {
          Authorization: `Bearer ${GITHUB_TOKEN}`,
          Accept: 'application/vnd.github.v3+json',
        },
      }
    );
    return { success: true, message: `Workflow ${workflowFile} triggered` };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

app.post('/execute', async (req, res) => {
  const { command } = req.body;

  if (!command) return res.status(400).json({ error: 'Missing command' });

  // Simple intent matching (expandable to NLP)
  if (command.toLowerCase().includes('deploy production')) {
    const response = await triggerWorkflow('deploy-prod.yml');
    return res.json(response);
  }

  if (command.toLowerCase().includes('run tests locally')) {
    // Here you can add logic to trigger local tests if your service has access
    // For example, spawn child process (not recommended on serverless)
    return res.json({ success: true, message: 'Local tests executed (stub).' });
  }

  if (command.toLowerCase().includes('rollback production')) {
    const response = await triggerWorkflow('rollback.yml');
    return res.json(response);
  }

  return res.json({ success: false, message: 'Command not recognized' });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Orchestrator running on port ${PORT}`));
