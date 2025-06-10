<script>
	let { onclick, children } = $props();
</script>

<button {onclick}>{@render children()}</button>

<style>
	button {
		color: var(--green);
		background-color: var(--orange-dim);
		border: none;
		border-radius: 5px;
		font-family: 'Schibsted Grotesk';
		font-size: 1em;
		font-weight: bold;
		cursor: pointer;
		transition: color 0.3s;
		transition: background-color 0.3s;

		&:hover {
			color: var(--fg1);
			background-color: var(--orange);
		}

		&:active {
			color: var(--fg1);
			background-color: var(--orange-dim);
		}
	}
</style>
