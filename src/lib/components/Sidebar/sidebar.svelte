<script>
	import Heading from "../heading.svelte";
	import { getPages } from '$lib/pages'; // Path to the utility function

	const { url } = import.meta;
	const modules = import.meta.glob('../../../routes/**/*.svelte'); // Include subfolder
	// const modules = import.meta.glob('./**.svelte'); // Current folder only
	const pages = getPages(url, modules);
	console.log('GERMAN pages', url, modules, pages)
</script>

<nav>
	<Heading level={2}>Sidebar</Heading>
</nav>

<style>
nav {
	height: 100%;
	padding: 1em;
}
</style>


