<script>
	import QRCode from 'qrcode';
	import { ArrowRight, CircleAlert, Download } from '@lucide/svelte';

	let inputText = $state('');
	let error = $state('');
	let qrDataUrl = $state('');
	let copied = $state(false);

	const sampleText = 'https://github.com';

	function loadSample() {
		inputText = sampleText;
	}

	function clearAll() {
		inputText = '';
		error = '';
		qrDataUrl = '';
		copied = false;
	}

	async function generate() {
		error = '';
		if (!inputText.trim()) {
			error = 'Please enter text or URL to generate a QR code.';
			return;
		}
		try {
			qrDataUrl = await QRCode.toDataURL(inputText.trim(), {
				width: 400,
				margin: 2,
				color: {
					dark: '#1a1a1a',
					light: '#ffffff'
				}
			});
			copied = false;
		} catch (e) {
			error = 'Failed to generate QR code: ' + e.message;
		}
	}

	async function download() {
		if (!qrDataUrl) return;
		const link = document.createElement('a');
		link.download = 'qrcode.png';
		link.href = qrDataUrl;
		link.click();
	}
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>QR Code Generator</h1>
		<p class="tool-description">Generate QR codes from text, URLs, or any other data.</p>
	</div>

	<div class="controls animate-fade-in">
		<div class="controls-row">
			<div class="control-group flex-1">
				<label for="qr-input">Content</label>
				<textarea
					id="qr-input"
					bind:value={inputText}
					placeholder="Enter text or URL..."
					spellcheck="false"
				></textarea>
			</div>
		</div>
	</div>

	<div class="actions">
		<button class="btn btn-primary" onclick={generate}>
			<ArrowRight size={16} />
			Generate QR Code
		</button>
		<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={clearAll} disabled={!inputText && !qrDataUrl}>Clear</button>
	</div>

	{#if error}
		<div class="error-banner animate-fade-in">
			<CircleAlert size={16} />
			{error}
		</div>
	{/if}

	{#if qrDataUrl}
		<div class="output-section animate-fade-in">
			<div class="output-header">
				<span class="output-label">QR Code</span>
			<button class="btn btn-secondary btn-sm" onclick={download}>
				<Download size={14} />
				Download PNG
				</button>
			</div>
			<div class="qr-display">
				<img src={qrDataUrl} alt="QR Code" />
			</div>
		</div>
	{/if}
</div>

<style>
	.tool-container {
		max-width: 1200px;
		margin: 0 auto;
		padding: 1rem;
		font-family: var(--font-family-sans);
	}

	.tool-header {
		margin-bottom: 2rem;
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

	@media (max-width: 768px) {
		.tool-header h1 {
			font-size: 1.5rem;
		}
	}

	.controls {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.5rem;
		margin-bottom: 1.5rem;
	}

	.controls-row {
		display: flex;
		gap: 1.5rem;
		flex-wrap: wrap;
	}

	.control-group {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
	}

	.control-group.flex-1 {
		flex: 1;
	}

	.control-group label {
		font-size: 0.8rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.control-group textarea {
		width: 100%;
		height: 100px;
		padding: 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--background);
		color: var(--text);
		font-family: var(--font-family-mono);
		font-size: 0.9rem;
		line-height: 1.5;
		resize: vertical;
		outline: none;
		transition: border-color 0.2s, box-shadow 0.2s;
	}

	.control-group textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-bottom: 1.5rem;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 0.75rem 1.5rem;
		font-size: 0.95rem;
		font-weight: 500;
		border-radius: var(--radius);
		border: 1px solid transparent;
		cursor: pointer;
		transition: background-color 0.15s, border-color 0.15s, color 0.15s, box-shadow 0.15s;
		user-select: none;
	}

	.btn-sm {
		padding: 0.4rem 0.9rem;
		font-size: 0.8rem;
	}

	.btn-primary {
		background: var(--primary);
		color: #ffffff;
	}

	.btn-primary:hover {
		background: var(--primary-hover);
	}

	.btn-primary:focus {
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.3);
	}

	.btn-secondary {
		background: var(--surface);
		color: var(--text);
		border-color: var(--border);
	}

	.btn-secondary:hover {
		background: var(--border);
	}

	.btn-tertiary {
		background: transparent;
		color: var(--text-secondary);
	}

	.btn-tertiary:hover {
		background: var(--surface);
		color: var(--text);
	}

	.btn-tertiary:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		background: transparent;
		color: var(--text-secondary);
	}

	.error-banner {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 1rem;
		margin-bottom: 1.5rem;
		background: rgba(239, 68, 68, 0.1);
		border: 1px solid rgba(239, 68, 68, 0.2);
		border-radius: var(--radius);
		color: #ef4444;
		font-size: 0.875rem;
	}

	[data-theme='dark'] .error-banner {
		background: rgba(239, 68, 68, 0.15);
		color: #f87171;
	}

	.output-section {
		margin-top: 0;
	}

	.output-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.75rem;
	}

	.output-label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.qr-display {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 2rem;
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
	}

	.qr-display img {
		max-width: 100%;
		max-height: 80vh;
		height: auto;
		image-rendering: pixelated;
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
</style>
