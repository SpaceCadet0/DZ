<!-- home page content tpl -->

{if $config.home_page_h1}
	<h1>{if $pageInfo.h1}{$pageInfo.h1}{else}{$pageInfo.name}{/if}</h1>
{/if}

{if $tpl_settings.home_page_gallery}
    <section class="home-content row">
    	<div class="gallary col-md-8 col-sm-12">
    		<div class="featured_gallery{if $demo_gallery} demo{/if}"><div class="preview"><a {if $config.featured_new_window}target="_blank"{/if} title="{$lang.view_details}" href="#"><div></div></a><div class="fg-title hide"></div><div class="fg-price hide"></div></div>
    		{insert name='eval' content=$gallary_content}
    		{if $demo_gallery}{assign var='demo_gallery' value=false}{/if}
    		</div>
    	</div>
    	
    	<div class="search-form col-md-4 col-sm-12">
    		{include file='blocks'|cat:$smarty.const.RL_DS|cat:'side_bar_search.tpl'}
    	</div>
    </section>
{/if}

<!-- home page content tpl end -->