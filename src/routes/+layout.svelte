<script>
	import Footer from '$lib/components/footer.svelte';
	import Header from '$lib/components/header.svelte';
	import Sidebar from '$lib/components/sidebar.svelte';

	let { children } = $props();
</script>

<main>
	<Header />
	<div class="content">
		<Sidebar />
		<div class="page-content">
			{@render children()}
		</div>
	</div>
	<Footer />
</main>

<style>
main {
	display: grid;
	grid-template-rows: 5vh 90vh 5vh;
}
.content {
	display: grid;
	grid-template-columns: 20vw 80vw;
	max-height: 90vh;
}
.page-content {
	display: block;
	height: 100%;
}
</style>
