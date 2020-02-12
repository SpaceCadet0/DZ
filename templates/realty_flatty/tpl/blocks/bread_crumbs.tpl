<!-- bread crumbs block -->

{if $bread_crumbs|@count > 2 && $pageInfo.Key != 'home'}
	<div id="bread_crumbs">
		<ul class="point1">
			{foreach from=$bread_crumbs item='breadCrumbs' name='fBreadC'}
				{if !$smarty.foreach.fBreadC.last}
					<li><a href="{$rlBase}{if $config.mod_rewrite}{if $breadCrumbs.path != ''}{$breadCrumbs.path}{if $breadCrumbs.category}{if $listing_type.Cat_postfix}.html{else}/{/if}{else}.html{/if}{/if}{if $breadCrumbs.vars}?{$breadCrumbs.vars}{/if}{else}{if $breadCrumbs.path != ''}?page={$breadCrumbs.path}{/if}{if $breadCrumbs.vars}&amp;{$breadCrumbs.vars}{/if}{/if}" title="{$breadCrumbs.title|strip_tags}">{if $smarty.foreach.fBreadC.first}{assign var='home_phrase' value='pages+name+home'}{$lang.$home_phrase}{else}{$breadCrumbs.name|strip_tags}{/if}</a> {if $smarty.foreach.fBreadC.iteration < $bread_crumbs|@count-1}<span>{if $smarty.const.RL_LANG_DIR == 'rtl'}\{else}/{/if}</span>{/if}</li>
				{/if}
			{/foreach}
		</ul>
	</div>
{/if}

<!-- bread crumbs block end -->