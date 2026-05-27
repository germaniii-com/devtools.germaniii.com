<script>
	import { theme, themes } from '$lib/stores/theme.js';
	import { Moon, Sun } from '@lucide/svelte';

	function toggleTheme() {
		theme.update((t) => (t === themes.dark ? themes.light : themes.dark));
	}
</script>

<header class="header">
	<div class="header-content">
		<div class="header-title">
			<h1 class="title">devtools.germaniii.com</h1>
			<p class="subtitle">your all-in-one developer toolbox</p>
		</div>
		<button class="theme-toggle" onclick={toggleTheme} aria-label="Toggle theme">
			{#if $theme === themes.dark}
				<Sun size={20} />
			{:else}
				<Moon size={20} />
			{/if}
		</button>
	</div>
</header>

<style>
	.header {
		height: 100%;
		text-align: center;
		padding: 1em 0;
		background: var(--surface);
		border-bottom: 1px solid var(--border);
		box-shadow: var(--shadow);
	}

	.header-content {
		display: grid;
		grid-template-columns: 1fr auto;
		justify-content: space-between;
		align-items: center;
		margin: 0 auto;
		padding: 0 2em;
	}

	.title {
		font-size: 1.8em;
		font-weight: 700;
		color: var(--text);
		letter-spacing: -0.02em;
		margin-bottom: 0.1em;
		font-family: var(--font-family-sans);
	}

	.subtitle {
		font-size: 0.9em;
		color: var(--text-secondary);
		font-weight: 400;
		margin: 0;
		font-family: var(--font-family-sans);
	}

	.theme-toggle {
		background: none;
		border: none;
		cursor: pointer;
		padding: 0.5em;
		border-radius: var(--radius);
		color: var(--text);
		transition: background-color 0.2s;
		align-items: center;
		justify-content: end;
	}

	.theme-toggle:hover {
		background: var(--border);
	}
</style>
