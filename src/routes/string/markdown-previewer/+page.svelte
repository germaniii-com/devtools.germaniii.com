<script>
	import { marked } from 'marked';
	import { X, Plus, Link, Code, List, ListOrdered, TextQuote, FileText, Download, Columns2, Monitor, PanelLeftOpen } from '@lucide/svelte';

	marked.setOptions({ breaks: true, gfm: true });

	let tabs = $state([{ id: 1, name: 'Untitled 1', content: '' }]);
	let activeTabId = $state(1);
	let viewMode = $state('split');
	let textareaRef = $state(null);
	let nextId = 2;
	let editingTabId = $state(null);
	let editName = $state('');

	let activeContent = $state('');

	$effect(() => {
		const content = activeContent;
		const tab = tabs.find((t) => t.id === activeTabId);
		if (tab) tab.content = content;
	});

	function switchTab(id) {
		const current = tabs.find((t) => t.id === activeTabId);
		if (current) current.content = activeContent;
		activeTabId = id;
		const next = tabs.find((t) => t.id === id);
		activeContent = next?.content ?? '';
	}

	const html = $derived(activeContent ? marked.parse(activeContent) : '');

	const stats = $derived({
		words: activeContent
			? activeContent.replace(/\s+/g, ' ').trim().split(' ').filter(Boolean).length
			: 0,
		chars: activeContent.length,
		lines: activeContent ? activeContent.split('\n').length : 0
	});

	function insert(before, after, placeholder) {
		const ta = textareaRef;
		if (!ta) return;
		const start = ta.selectionStart;
		const end = ta.selectionEnd;
		const selected = activeContent.substring(start, end);
		const text = selected || placeholder;
		activeContent =
			activeContent.substring(0, start) + before + text + after + activeContent.substring(end);
		requestAnimationFrame(() => {
			ta.focus();
			ta.setSelectionRange(start + before.length, start + before.length + text.length);
		});
	}

	function insertInline(before, after, placeholder) {
		return () => insert(before, after, placeholder);
	}

	function insertBlock(before, placeholder) {
		return () => insert('\n' + before, '', placeholder);
	}

	function insertCodeBlock() {
		const ta = textareaRef;
		if (!ta) return;
		const start = ta.selectionStart;
		const end = ta.selectionEnd;
		const selected = activeContent.substring(start, end);
		const text = selected || 'code';
		activeContent =
			activeContent.substring(0, start) +
			'\n```\n' +
			text +
			'\n```\n' +
			activeContent.substring(end);
		requestAnimationFrame(() => {
			ta.focus();
			const pos = start + 5 + text.length + 5;
			ta.setSelectionRange(pos, pos);
		});
	}

	function insertHr() {
		const ta = textareaRef;
		if (!ta) return;
		const pos = ta.selectionStart;
		activeContent =
			activeContent.substring(0, pos) + '\n---\n' + activeContent.substring(ta.selectionEnd);
		requestAnimationFrame(() => {
			ta.focus();
			ta.setSelectionRange(pos + 5, pos + 5);
		});
	}

	function downloadMarkdown() {
		const blob = new Blob([activeContent], { type: 'text/markdown' });
		const url = URL.createObjectURL(blob);
		const tab = tabs.find((t) => t.id === activeTabId);
		const name = tab?.name ?? 'document';
		const a = document.createElement('a');
		a.href = url;
		a.download = name.replace(/\s+/g, '-').toLowerCase() + '.md';
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		URL.revokeObjectURL(url);
	}

	function addTab() {
		const id = nextId++;
		tabs = [...tabs, { id, name: `Untitled ${id}`, content: '' }];
		switchTab(id);
	}

	function closeTab(id) {
		if (tabs.length <= 1) return;
		const idx = tabs.findIndex((t) => t.id === id);
		tabs = tabs.filter((t) => t.id !== id);
		if (activeTabId === id) {
			switchTab(tabs[Math.min(idx, tabs.length - 1)].id);
		}
	}

	function startRename(id) {
		const tab = tabs.find((t) => t.id === id);
		if (!tab) return;
		editingTabId = id;
		editName = tab.name;
	}

	function finishRename() {
		const tab = tabs.find((t) => t.id === editingTabId);
		if (tab && editName.trim()) {
			tab.name = editName.trim();
		}
		editingTabId = null;
	}

	const sample = `# Markdown Editor Sample

## Text Formatting

This is **bold** text, this is *italic* text, and this is ~~strikethrough~~.

## Lists

### Unordered
- Item 1
- Item 2
- Item 3

### Ordered
1. First
2. Second
3. Third

## Code

Inline \`code\` looks like this.

\`\`\`javascript
function hello() {
	console.log("Hello, world!");
}
\`\`\`

## Blockquote

> The only way to do great work is to love what you do.

## Links

[Visit GitHub](https://github.com)

## Table

| Name  | Age |
|-------|-----|
| Alice | 30  |
| Bob   | 25  |

---

> Sample markdown content to get you started!
`;

	function loadSample() {
		activeContent = sample;
	}
</script>

<div class="md-editor-container">
	<div class="tool-header">
		<h1>Markdown Editor</h1>
		<p class="tool-description">Write and preview markdown in real-time with formatting tools.</p>
	</div>

	<div class="tab-bar">
		{#each tabs as tab (tab.id)}
			<div
				class="tab {tab.id === activeTabId ? 'active' : ''}"
				role="tab"
				tabindex="0"
				onclick={() => switchTab(tab.id)}
			>
				{#if editingTabId === tab.id}
					<input
						class="tab-rename-input"
						bind:value={editName}
						onclick={(e) => e.stopPropagation()}
						onblur={finishRename}
						onkeydown={(e) => {
							if (e.key === 'Enter') finishRename();
							if (e.key === 'Escape') editingTabId = null;
						}}
						autofocus
					/>
				{:else}
					<span class="tab-name" ondblclick={() => startRename(tab.id)}>{tab.name}</span>
				{/if}
				<button
					class="tab-close"
					onclick={(e) => {
						e.stopPropagation();
						closeTab(tab.id);
					}}
					title="Close tab"
				>
					<X size={14} />
				</button>
			</div>
		{/each}
		<button class="tab-add" onclick={addTab} title="New tab">
			<Plus size={16} />
		</button>
	</div>

	{#snippet toolbarContent()}
		<button class="toolbar-btn" onclick={insertInline('**', '**', 'bold text')} title="Bold">
			<strong>B</strong>
		</button>
		<button class="toolbar-btn" onclick={insertInline('*', '*', 'italic text')} title="Italic">
			<em>I</em>
		</button>
		<button
			class="toolbar-btn"
			onclick={insertInline('~~', '~~', 'strikethrough')}
			title="Strikethrough"
		>
			<span class="linethrough">S</span>
		</button>
		<span class="toolbar-divider"></span>
		<button class="toolbar-btn" onclick={insertInline('## ', '', 'Heading')} title="Heading">
			H
		</button>
		<button class="toolbar-btn" onclick={insertInline('[', '](url)', 'link text')} title="Link">
			<Link size={16} />
		</button>
		<span class="toolbar-divider"></span>
		<button class="toolbar-btn" onclick={insertInline('`', '`', 'code')} title="Inline Code">
			<code>&lt;&gt;</code>
		</button>
		<button class="toolbar-btn" onclick={insertCodeBlock} title="Code Block">
			<Code size={16} />
		</button>
		<span class="toolbar-divider"></span>
		<button class="toolbar-btn" onclick={insertBlock('- ', 'list item')} title="Unordered List">
			<List size={16} />
		</button>
		<button class="toolbar-btn" onclick={insertBlock('1. ', 'list item')} title="Ordered List">
			<ListOrdered size={16} />
		</button>
		<button class="toolbar-btn" onclick={insertBlock('> ', 'quote')} title="Blockquote">
			<TextQuote size={16} />
		</button>
		<button class="toolbar-btn" onclick={insertHr} title="Horizontal Rule"> — </button>
		<span class="toolbar-divider"></span>
		<button class="toolbar-btn" onclick={loadSample} title="Load Sample">
			<FileText size={16} />
		</button>
		<button
			class="toolbar-btn"
			onclick={downloadMarkdown}
			disabled={!activeContent}
			title="Download .md"
		>
			<Download size={16} />
		</button>
		<span class="toolbar-spacer"></span>
		<div class="toolbar-stats">
			<span>{stats.words} words</span>
			<span class="stat-divider"></span>
			<span>{stats.chars} chars</span>
			<span class="stat-divider"></span>
			<span>{stats.lines} lines</span>
		</div>
		<span class="toolbar-divider"></span>
		<button
			class="toolbar-btn"
			class:active={viewMode !== 'editor'}
			onclick={() => {
				if (viewMode === 'split') viewMode = 'preview';
				else if (viewMode === 'preview') viewMode = 'editor';
				else viewMode = 'split';
			}}
			title={viewMode === 'split'
				? 'Preview only'
				: viewMode === 'preview'
					? 'Editor only'
					: 'Split view'}
		>
			{#if viewMode === 'split'}
				<Columns2 size={16} />
			{:else if viewMode === 'preview'}
				<Monitor size={16} />
			{:else}
				<PanelLeftOpen size={16} />
			{/if}
		</button>
	{/snippet}

	<div
		class="editor-layout animate-fade-in"
		class:view-preview={viewMode === 'preview'}
		class:view-editor={viewMode === 'editor'}
	>
		<div class="toolbox">
			{@render toolbarContent()}
		</div>
		<div class="editor-pane" class:hidden={viewMode === 'preview'}>
			<textarea
				bind:this={textareaRef}
				bind:value={activeContent}
				placeholder="Type markdown here..."
				spellcheck="false"
			></textarea>
		</div>
		{#if viewMode !== 'editor'}
			<div class="preview-pane">
				<div class="preview-content">
					{#if html}
						{@html html}
					{:else}
						<div class="preview-empty">
							<p>Start typing markdown to see the preview here.</p>
						</div>
					{/if}
				</div>
			</div>
		{/if}
	</div>
</div>

<style>
	.md-editor-container {
		max-width: 1400px;
		margin: 0 auto;
		padding: 1rem;
		font-family: var(--font-family-sans);
	}

	.tool-header {
		margin-bottom: 1rem;
	}

	.tool-header h1 {
		font-size: 2rem;
		font-weight: 700;
		color: var(--text);
		margin-bottom: 0.5rem;
	}

	.tool-description {
		font-size: 1rem;
		color: var(--text-secondary);
	}

	/* Tab Bar */
	.tab-bar {
		display: flex;
		align-items: stretch;
		gap: 0;
		margin-bottom: 0;
		overflow-x: auto;
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius) var(--radius) 0 0;
		border-bottom: none;
		padding: 0;
	}

	.tab {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.5rem 0.75rem;
		font-size: 0.85rem;
		color: var(--text-secondary);
		border-right: 1px solid var(--border);
		cursor: pointer;
		user-select: none;
		transition:
			background-color 0.15s,
			color 0.15s;
		min-width: 0;
		white-space: nowrap;
	}

	.tab:hover {
		background: var(--border);
		color: var(--text);
	}

	.tab.active {
		background: var(--background);
		color: var(--text);
		font-weight: 600;
	}

	.tab-name {
		max-width: 120px;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tab-rename-input {
		font-family: var(--font-family-sans);
		font-size: 0.85rem;
		padding: 0.1rem 0.25rem;
		border: 1px solid var(--primary);
		border-radius: 3px;
		background: var(--background);
		color: var(--text);
		outline: none;
		width: 100px;
	}

	.tab-close {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0;
		border: none;
		background: transparent;
		color: var(--text-secondary);
		cursor: pointer;
		border-radius: 3px;
		opacity: 0;
		transition:
			opacity 0.15s,
			background-color 0.15s,
			color 0.15s;
		flex-shrink: 0;
	}

	.tab:hover .tab-close,
	.tab.active .tab-close {
		opacity: 1;
	}

	.tab-close:hover {
		background: rgba(239, 68, 68, 0.15);
		color: #ef4444;
	}

	.tab-add {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.5rem 0.75rem;
		border: none;
		background: transparent;
		color: var(--text-secondary);
		cursor: pointer;
		transition:
			background-color 0.15s,
			color 0.15s;
		flex-shrink: 0;
	}

	.tab-add:hover {
		background: var(--border);
		color: var(--text);
	}

	.animate-fade-in {
		animation: fadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1);
	}

	@keyframes fadeIn {
		from {
			opacity: 0;
			transform: translateY(4px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}

	.editor-layout {
		display: grid;
		grid-template-columns: 1fr 1fr;
		grid-template-rows: auto 1fr;
		min-height: 600px;
	}

	.editor-layout.view-editor {
		grid-template-columns: 1fr;
	}

	.editor-layout.view-preview {
		grid-template-columns: 1fr;
	}

	@media (max-width: 900px) {
		.editor-layout {
			grid-template-columns: 1fr;
			gap: 1.5rem;
		}
	}

	/* Toolbox */
	.toolbox {
		grid-column: 1 / -1;
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.25rem;
		padding: 0.5rem;
		background: var(--surface);
		border: 1px solid var(--border);
		border-bottom: none;
	}

	.toolbar-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		padding: 0;
		border: none;
		border-radius: 4px;
		background: transparent;
		color: var(--text);
		font-size: 0.85rem;
		cursor: pointer;
		transition: background-color 0.15s;
		user-select: none;
	}

	.toolbar-btn:hover {
		background: var(--border);
	}

	.toolbar-btn:active {
		background: var(--text-secondary);
		color: var(--background);
	}

	.toolbar-btn strong,
	.toolbar-btn em {
		font-style: normal;
		font-weight: 700;
		font-size: 0.95rem;
	}

	.toolbar-btn code {
		font-family: var(--font-family-mono);
		font-size: 0.75rem;
		background: none;
		padding: 0;
	}

	.linethrough {
		text-decoration: line-through;
	}

	.toolbar-divider {
		width: 1px;
		height: 1.25rem;
		background: var(--border);
		margin: 0 0.25rem;
	}

	.toolbar-spacer {
		flex: 1;
	}

	.toolbar-btn.active {
		color: var(--primary);
	}

	.editor-pane.hidden {
		display: none;
	}

	/* Textarea */
	.editor-pane textarea {
		width: 100%;
		height: 100%;
		min-height: 300px;
		padding: 1rem;
		border: 1px solid var(--border);
		border-top: none;
		border-radius: 0 0 var(--radius) var(--radius);
		background: var(--background);
		color: var(--text);
		font-family: var(--font-family-mono);
		font-size: 0.875rem;
		line-height: 1.6;
		resize: vertical;
		outline: none;
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
		tab-size: 4;
	}

	.editor-pane textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	/* Toolbar Stats */
	.toolbar-stats {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 0.75rem;
		color: var(--text-secondary);
		white-space: nowrap;
	}

	@media (max-width: 768px) {
		.tool-header h1 {
			font-size: 1.5rem;
		}

		.toolbar-stats {
			display: none;
		}
	}

	.toolbar-stats .stat-divider {
		width: 1px;
		height: 1rem;
		background: var(--border);
	}

	/* Preview Pane */
	.preview-pane {
		display: flex;
		flex-direction: column;
		border: 1px solid var(--border);
		border-radius: 0 0 var(--radius) var(--radius);
		overflow: hidden;
		background: var(--background);
	}

	.preview-content {
		flex: 1;
		padding: 1.5rem;
		overflow-y: auto;
		line-height: 1.7;
	}

	.preview-content :global(h1),
	.preview-content :global(h2),
	.preview-content :global(h3),
	.preview-content :global(h4) {
		margin-top: 1.5rem;
		margin-bottom: 0.75rem;
		font-weight: 600;
		color: var(--text);
		line-height: 1.3;
	}

	.preview-content :global(h1) {
		font-size: 2rem;
		border-bottom: 1px solid var(--border);
		padding-bottom: 0.3rem;
	}

	.preview-content :global(h2) {
		font-size: 1.5rem;
		border-bottom: 1px solid var(--border);
		padding-bottom: 0.3rem;
	}

	.preview-content :global(h3) {
		font-size: 1.25rem;
	}

	.preview-content :global(p) {
		margin-bottom: 1rem;
		color: var(--text);
	}

	.preview-content :global(a) {
		color: var(--primary);
		text-decoration: none;
	}

	.preview-content :global(a:hover) {
		text-decoration: underline;
	}

	.preview-content :global(strong) {
		font-weight: 700;
	}

	.preview-content :global(em) {
		font-style: italic;
	}

	.preview-content :global(code) {
		font-family: var(--font-family-mono);
		font-size: 0.85em;
		background: var(--surface);
		padding: 0.15em 0.4em;
		border-radius: 3px;
		color: var(--text);
	}

	.preview-content :global(pre) {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1rem;
		overflow-x: auto;
		margin-bottom: 1rem;
	}

	.preview-content :global(pre code) {
		background: none;
		padding: 0;
		border-radius: 0;
		font-size: 0.85rem;
		line-height: 1.5;
	}

	.preview-content :global(blockquote) {
		margin: 0 0 1rem 0;
		padding: 0.5rem 1rem;
		border-left: 4px solid var(--primary);
		background: var(--surface);
		border-radius: 0 var(--radius) var(--radius) 0;
		color: var(--text-secondary);
	}

	.preview-content :global(ul),
	.preview-content :global(ol) {
		margin-bottom: 1rem;
		padding-left: 1.5rem;
		color: var(--text);
	}

	.preview-content :global(li) {
		margin-bottom: 0.25rem;
	}

	.preview-content :global(table) {
		width: 100%;
		border-collapse: collapse;
		margin-bottom: 1rem;
	}

	.preview-content :global(th),
	.preview-content :global(td) {
		padding: 0.5rem 0.75rem;
		border: 1px solid var(--border);
		text-align: left;
		font-size: 0.875rem;
	}

	.preview-content :global(th) {
		background: var(--surface);
		font-weight: 600;
	}

	.preview-content :global(hr) {
		border: none;
		border-top: 1px solid var(--border);
		margin: 1.5rem 0;
	}

	.preview-content :global(img) {
		max-width: 100%;
		border-radius: var(--radius);
	}

	.preview-empty {
		display: flex;
		align-items: center;
		justify-content: center;
		min-height: 200px;
		color: var(--text-secondary);
	}
</style>
