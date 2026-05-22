<nav class="sidebar">
	<div class="group">
		<h2>String Utilities</h2>
		<ul>
			<li>Text Compare</li>
			<li>Regex Test</li>
			<li>Case Convert</li>
			<li>String Analyzer</li>
			<li>Markdown Previewer</li>
		</ul>
	</div>

	<div class="group">
		<h2>Formatters</h2>
		<ul>
			<li>JSON Formatting</li>
			<li>XML Formatter</li>
			<li>HTML/CSS/JS Formatter (Prettier)</li>
			<li>Code Minifier</li>
		</ul>
	</div>

	<div class="group">
		<h2>Encoder/Decoders</h2>
		<ul>
			<li>Base64 Encode/Decode</li>
			<li>URL Encode/Decode</li>
			<li>JWT Decode</li>
			<li>HTML Entity Decode</li>
		</ul>
	</div>

	<div class="group">
		<h2>Data Converters</h2>
		<ul>
			<li>JSON to YAML</li>
			<li>JSON to CSV</li>
			<li>CSV to JSON</li>
			<li>Color Converter</li>
			<li>Timestamp Converter</li>
		</ul>
	</div>

	<div class="group">
		<h2>Generators</h2>
		<ul>
			<li>UUID / ULID / GUID</li>
			<li>Hash Generator</li>
			<li>Lorem Ipsum Generator</li>
			<li>Strong Password Generator</li>
			<li>QR Code Generator</li>
		</ul>
	</div>
</nav>

<style>
	.sidebar {
		height: 100%;
		width: var(--sidebar-width);
		overflow-y: auto;
		background: var(--surface);
		border-right: 1px solid var(--border);
		padding: 1.5rem;
		z-index: 999;
	}

	.group {
		margin-bottom: 1.5rem;
	}

	.group h2 {
		font-size: 0.85rem;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		color: var(--text-secondary);
		margin-bottom: 0.5rem;
		font-weight: 600;
		font-family: var(--font-family-sans);
	}

	.group ul {
		list-style: none;
		padding: 0;
		margin: 0;
	}

	.group li {
		padding: 0.35rem 0.75rem;
		border-radius: var(--radius);
		margin-bottom: 0.15rem;
		cursor: pointer;
		transition:
			background-color 0.15s,
			color 0.15s;
		color: var(--text);
		font-size: 0.85rem;
		font-family: var(--font-family-sans);
	}

	.group li:hover {
		background: var(--primary);
		color: #ffffff;
	}
</style>
