<script>
	import ListItem from './sidebar-list-item.svelte';

	let { items } = $props();
</script>

<ul>
	{#each items as item (item.id)}
		<ListItem {item} />
	{/each}
</ul>

<style>
	ul {
		list-style-type: none;
		padding: 0 1em;
		margin: 0;
		font-size: 0.8em;
	}
</style>
