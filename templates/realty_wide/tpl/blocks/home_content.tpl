<!-- home page content tpl -->

<section class="home-search">
	<div class="point1">
		{if $config.home_page_h1}
            <h1 class="align-center">{if $pageInfo.h1}{$pageInfo.h1}{else}{$pageInfo.name}{/if}</h1>
        {/if}

		<div id="search_area">
			{include file='blocks'|cat:$smarty.const.RL_DS|cat:'horizontal_search.tpl'}
		</div>
	</div>
</section>

<!-- home page content tpl end -->
