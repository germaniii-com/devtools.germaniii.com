<script>
	import { PanelLeftClose, PanelLeftOpen } from '@lucide/svelte';

	let { collapsed = false, ontoggle } = $props();

	const navigation = [
		{
			title: 'String Utilities',
			items: [
				{ name: 'Text Compare', path: '/string/text-compare' },
				{ name: 'Regex Test', path: '/string/regex-test' },
				{ name: 'Case Convert', path: '/string/case-convert' },
				{ name: 'String Analyzer', path: '/string/string-analyzer' },
				{ name: 'Markdown Previewer', path: '/string/markdown-previewer' },
				{ name: 'String Shorteners', path: '/string/string-shorteners' }
			]
		},
		{
			title: 'Formatters',
			items: [
				{ name: 'JSON Formatting', path: '/formatters/json' },
				{ name: 'XML Formatter', path: '/formatters/xml' },
				{ name: 'HTML/CSS/JS Formatter', path: '/formatters/prettier' },
				{ name: 'Code Minifier', path: '/formatters/minifier' }
			]
		},
		{
			title: 'Encoder/Decoders',
			items: [
				{ name: 'Base64 Encode/Decode', path: '/encoding/base64' },
				{ name: 'URL Encode/Decode', path: '/encoding/url' },
				{ name: 'JWT Decode', path: '/encoding/jwt' },
				{ name: 'HTML Entity Decode', path: '/encoding/html-entity' }
			]
		},
		{
			title: 'Data Converters',
			items: [
				{ name: 'JSON / YAML Converter', path: '/converters/json-yaml' },
				{ name: 'JSON / CSV Converter', path: '/converters/json-csv' },
				{ name: 'Color Converter', path: '/converters/color' },
				{ name: 'Timestamp Converter', path: '/converters/timestamp' },
				{ name: 'Timezone Converter', path: '/converters/timezone' }
			]
		},
		{
			title: 'Generators',
			items: [
				{ name: 'UUID / ULID / GUID', path: '/generators/uuid' },
				{ name: 'Hash Generator', path: '/generators/hash' },
				{ name: 'Lorem Ipsum Generator', path: '/generators/lorem-ipsum' },
				{ name: 'Strong Password Generator', path: '/generators/password' },
				{ name: 'QR Code Generator', path: '/generators/qr-code' }
			]
		}
	];
</script>

<nav class="sidebar" class:collapsed>
	<button class="toggle-btn" onclick={ontoggle} aria-label={collapsed ? 'Expand sidebar' : 'Collapse sidebar'}>
		{#if collapsed}
			<PanelLeftOpen size={20} />
		{:else}
			<PanelLeftClose size={20} />
		{/if}
	</button>
	{#if !collapsed}
		<div class="sidebar-content">
			{#each navigation as group (group.title)}
				<div class="group">
					<h2>{group.title}</h2>
					<ul>
						{#each group.items as item (item.path)}
							<li>
								<a href={item.path} class="nav-link">
									{item.name}
								</a>
							</li>
						{/each}
					</ul>
				</div>
			{/each}
		</div>
	{/if}
</nav>

<style>
	.sidebar {
		position: relative;
		height: 100%;
		width: var(--sidebar-width);
		overflow: hidden;
		background: var(--surface);
		border-right: 1px solid var(--border);
		padding: 1.5rem;
		flex-shrink: 0;
		transition: width 0.2s ease;
		z-index: 999;
		display: flex;
		flex-direction: column;
	}

	.sidebar.collapsed {
		width: 48px;
		padding: 1.5rem 0;
	}

	@media (max-width: 768px) {
		.sidebar.collapsed:hover {
			background: var(--border);
		}
	}

	.toggle-btn {
		position: absolute;
		top: 1.5rem;
		right: 1.5rem;
		z-index: 1;
		background: var(--surface);
		border: 1px solid var(--border);
		cursor: pointer;
		padding: 0.3rem;
		border-radius: var(--radius);
		color: var(--text-secondary);
		display: flex;
		align-items: center;
		justify-content: center;
		transition: right 0.2s ease, background-color 0.15s;
	}

	.sidebar.collapsed .toggle-btn {
		background: var(--surface);
		border-color: var(--border);
		box-shadow: var(--shadow);
	}

	.sidebar.collapsed .toggle-btn {
		right: 0.5rem;
	}

	.toggle-btn:hover {
		background: var(--border);
		color: var(--text);
	}

	.sidebar-content {
		flex: 1;
		overflow-y: auto;
		min-height: 0;
		scrollbar-width: none;
	}

	.sidebar-content::-webkit-scrollbar {
		display: none;
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

	.nav-link {
		display: block;
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
		text-decoration: none;
	}

	.nav-link:hover {
		background: var(--primary);
		color: #ffffff;
	}
</style>
