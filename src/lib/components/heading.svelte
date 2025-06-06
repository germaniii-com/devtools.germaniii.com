<script>
	let { level, children } = $props();
</script>

{#if level == 1}
	<h2>{@render children()}</h2>
{:else if level == 2}
	<h3>{@render children()}</h3>
{:else if level == 3}
	<h4>{@render children()}</h4>
{:else}
	<h1>{@render children()}</h1>
{/if}

<style>
	h1,
	h2,
	h3,
	h4 {
		font-family: 'Schibsted Grotesk';
		color: var(--orange);
	}

	h1,
	h2 {
		color: var(--yellow-dim);
	}
</style>
