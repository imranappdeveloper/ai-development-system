const projectPicker = document.getElementById("project-picker");
const projectsBody = document.getElementById("projects-body");
const logList = document.getElementById("log-list");
const updatedAt = document.getElementById("updated-at");
const projectCount = document.getElementById("project-count");
const logHeading = document.getElementById("log-heading");
const FILTER_KEY = "observe-dashboard-project";

let registryProjects = [];
let selectedProject = sessionStorage.getItem(FILTER_KEY) || "all";
let snapshotCache = { projects: [], events: [] };

function isFiltered() {
  return selectedProject && selectedProject !== "all";
}

function registryEntry(filter) {
  if (!filter || filter === "all") return null;
  const key = filter.toLowerCase();
  return (
    registryProjects.find(
      (p) =>
        p.id === filter ||
        p.name === filter ||
        p.path === filter ||
        (p.id || "").toLowerCase() === key ||
        (p.name || "").toLowerCase() === key
    ) || null
  );
}

function projectKeys(filter) {
  const keys = new Set();
  if (!filter || filter === "all") return keys;
  keys.add(filter);
  keys.add(filter.toLowerCase());
  const entry = registryEntry(filter);
  if (entry) {
    for (const value of [entry.id, entry.name, entry.path]) {
      if (value) {
        keys.add(value);
        keys.add(String(value).toLowerCase());
      }
    }
  }
  return keys;
}

function matchesSelectedProject(item, filter) {
  if (!filter || filter === "all") return true;
  const keys = projectKeys(filter);
  const candidates = [
    item.id,
    item.name,
    item.path,
    item.project,
    item.project_path,
  ].filter(Boolean);
  return candidates.some((value) => {
    const text = String(value);
    return keys.has(text) || keys.has(text.toLowerCase());
  });
}

function formatEvent(e) {
  const et = e.event_type || "?";
  if (et === "script_invoked") {
    const st = e.status ? ` (${e.status})` : "";
    return `script ${e.script || "?"}${st}`;
  }
  if (et === "files_used") {
    const n = (e.files || []).length;
    return `files_used (${n})`;
  }
  if (et === "mcp_probe") {
    return `mcp ${e.target || "?"} → ${e.status || "?"}`;
  }
  if (et === "mcp_call") {
    const tool = e.mcp_tool || e.step || "survey";
    const srv = e.mcp_server || e.target || "codebase-survey";
    const n = (e.files || []).length;
    const fr = (e.files_read || []).length;
    const fb = e.fallback_recommended ? " fallback" : "";
    return `mcp ${srv}/${tool} (${fr}/${n} files, ${e.duration_sec || 0}s)${fb}`;
  }
  if (et === "step_start" || et === "step_end") {
    const issue = e.issue ? ` #${e.issue}` : "";
    const step = e.step || et;
    return `${step}${issue}`;
  }
  if (et === "run_start" || et === "observe_run_start") {
    return `run_start skill=${e.skill || "?"}`;
  }
  if (et === "run_end" || et === "observe_run_end") {
    return `run_end ${e.status || ""}`.trim();
  }
  return et;
}

function isSessionActive(p) {
  if (typeof p.session_active === "boolean") {
    return p.session_active;
  }
  return p.health === "active" && !!p.run_id;
}

function actionButtons(p) {
  const id = p.id || p.name;
  const active = isSessionActive(p);
  const startDisabled = active ? "disabled" : "";
  const stopDisabled = active ? "" : "disabled";
  return `<div class="row-actions">
    <button type="button" class="btn btn-start" data-action="start" data-project="${escapeHtml(id)}" ${startDisabled}>Start</button>
    <button type="button" class="btn btn-stop" data-action="stop" data-project="${escapeHtml(id)}" ${stopDisabled}>Stop</button>
  </div>`;
}

function selectedLabel() {
  if (!isFiltered()) return "All projects";
  const entry = registryEntry(selectedProject);
  return entry?.name || selectedProject;
}

function updateLogHeading() {
  if (logHeading) {
    logHeading.textContent = `Activity log — ${selectedLabel()}`;
  }
  document.body.classList.toggle("filtered-view", isFiltered());
}

function renderProjectPicker(projects) {
  const chips = [
    `<button type="button" class="project-chip${selectedProject === "all" ? " active" : ""}" data-project="all">All projects</button>`,
  ];
  for (const p of projects) {
    const id = p.id || p.name;
    const active = selectedProject === id ? " active" : "";
    chips.push(
      `<button type="button" class="project-chip${active}" data-project="${escapeHtml(id)}">${escapeHtml(p.name)}</button>`
    );
  }
  projectPicker.innerHTML = chips.join("");
}

function renderProjects(projects) {
  if (!projects.length) {
    projectsBody.innerHTML =
      '<tr><td colspan="7" class="empty">No projects registered. Run <code>ai-new .</code> or <code>observe dashboard</code> from a bound project.</td></tr>';
    return;
  }
  projectsBody.innerHTML = projects
    .map((p) => {
      const sessionActive = isSessionActive(p);
      const healthLabel = sessionActive ? "active" : p.activity_recent ? "recent" : "idle";
      const healthClass = sessionActive ? "active" : p.activity_recent ? "recent" : "idle";
      const elapsed =
        sessionActive && p.elapsed_sec != null ? `${p.elapsed_sec}s` : "—";
      const step = p.step ? `${p.step}${p.issue ? ` #${p.issue}` : ""}` : "—";
      const id = p.id || p.name;
      const rowSelected = selectedProject === id ? " selected" : "";
      return `<tr class="project-row${rowSelected}" data-project="${escapeHtml(id)}">
        <td><strong>${escapeHtml(p.name)}</strong></td>
        <td><span class="badge ${healthClass}">${healthLabel}</span></td>
        <td>${escapeHtml(sessionActive ? p.run_id || "—" : "—")}</td>
        <td>${escapeHtml(p.last_script || p.last_skill || "—")}</td>
        <td>${escapeHtml(step)}</td>
        <td>${elapsed}</td>
        <td>${actionButtons(p)}</td>
      </tr>`;
    })
    .join("");
}

function renderLogs(events) {
  const visible = events.filter((e) => matchesSelectedProject(e, selectedProject));
  if (!visible.length) {
    const message = isFiltered()
      ? "No telemetry for the selected project yet."
      : 'No telemetry yet. Run ADS scripts or <code>observe watch</code> in a project.';
    logList.innerHTML = `<div class="empty">${message}</div>`;
    return;
  }
  logList.innerHTML = visible
    .map(
      (e) => `<div class="log-item">
      <span class="log-ts">${escapeHtml((e.ts || "").replace("T", " ").replace("Z", ""))}</span>
      <span class="log-project col-project">${escapeHtml(e.project || "?")}</span>
      <span class="log-detail">${escapeHtml(formatEvent(e))}</span>
    </div>`
    )
    .join("");
}

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function selectProject(projectId) {
  selectedProject = projectId || "all";
  sessionStorage.setItem(FILTER_KEY, selectedProject);
  updateLogHeading();
  renderProjectPicker(snapshotCache.projects);
  renderProjects(snapshotCache.projects);
  renderLogs(snapshotCache.events);
  projectCount.textContent = isFiltered()
    ? `Logs: ${selectedLabel()}`
    : `${snapshotCache.projects.length} projects`;
}

function updateFooter(data) {
  projectCount.textContent = isFiltered()
    ? `Logs: ${selectedLabel()}`
    : `${data.registry_count || snapshotCache.projects.length} projects`;
}

function renderAll() {
  renderProjectPicker(snapshotCache.projects);
  renderProjects(snapshotCache.projects);
  renderLogs(snapshotCache.events);
  updateLogHeading();
}

async function refresh() {
  try {
    const res = await fetch("/api/snapshot?project=all");
    const data = await res.json();
    snapshotCache = {
      projects: data.projects || [],
      events: data.events || [],
    };
    registryProjects = snapshotCache.projects.map((p) => ({
      id: p.id,
      name: p.name,
      path: p.path,
    }));
    if (
      isFiltered() &&
      !snapshotCache.projects.some((p) => (p.id || p.name) === selectedProject)
    ) {
      selectedProject = "all";
      sessionStorage.setItem(FILTER_KEY, "all");
    }
    renderAll();
    updateFooter(data);
    updatedAt.textContent = `Updated ${data.ts || "—"}`;
  } catch (err) {
    updatedAt.textContent = `Error: ${err.message}`;
  }
}

async function readJsonResponse(res, action) {
  const ct = res.headers.get("content-type") || "";
  if (!ct.includes("application/json")) {
    throw new Error(
      "Dashboard server is outdated. Stop it (Ctrl-C in its terminal), then run: observe dashboard"
    );
  }
  const data = await res.json();
  if (!res.ok && !data.ok) {
    throw new Error(data.error || `${action} failed (${res.status})`);
  }
  return data;
}

async function observeAction(action, projectId) {
  const res = await fetch(`/api/observe/${action}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ project: projectId }),
  });
  const data = await readJsonResponse(res, action);
  if (!data.ok) {
    throw new Error(data.error || `${action} failed`);
  }
  return data;
}

projectPicker.addEventListener("click", (event) => {
  const chip = event.target.closest(".project-chip");
  if (!chip) return;
  selectProject(chip.dataset.project);
});

projectsBody.addEventListener("click", async (event) => {
  const btn = event.target.closest("button[data-action]");
  if (btn) {
    if (btn.disabled) return;
    const action = btn.dataset.action;
    const projectId = btn.dataset.project;
    btn.disabled = true;
    try {
      await observeAction(action, projectId);
      await refresh();
    } catch (err) {
      updatedAt.textContent = `Error: ${err.message}`;
      btn.disabled = false;
    }
    return;
  }
  const row = event.target.closest("tr.project-row");
  if (row) {
    selectProject(row.dataset.project);
  }
});

const dashboardUrl = document.getElementById("dashboard-url");
if (dashboardUrl) {
  dashboardUrl.href = window.location.origin + "/";
  dashboardUrl.textContent = window.location.origin + "/";
}

refresh();
setInterval(refresh, 5000);