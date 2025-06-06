<script>
	import Heading from './heading.svelte';
	import items from '../constants/pages';
	import List from './sidebar-list.svelte';
</script>

<nav>
	<Heading level={2}>Tools</Heading>
	<List {items} />
</nav>

<style>
	nav {
		height: 100%;
		padding: 1em;
	}
</style>
