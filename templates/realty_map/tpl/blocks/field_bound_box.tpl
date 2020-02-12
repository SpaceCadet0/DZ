<!-- custom field bound boxes -->

{if !empty($options)}
	<ul class="field-bound-box{if !$icons} list{/if}">
		{foreach from=$options item='option' name='fCats'}{strip}
			<li class="{$icons_position}{if $show_count && !$option.Count} empty{/if}">
				<a title="{$lang[$option.pName]}" {if $icons}class="hint"{/if} href="{$rlBase}{if $config.mod_rewrite}{$path}/{$option.Key}{if $html_postfix}.html{else}/{/if}{else}?page={$pages.listings_by_field}&amp;{$path}={$option.Key}{/if}">
					{if $option.Icon}
						<img style="{if $icons_width}width: {$icons_width}px;{/if}{if $icons_height}height: {$icons_height}px;{/if}" src="{$smarty.const.RL_FILES_URL}{$option.Icon}" alt="{$lang[$option.pName]}" />
					{else}
						{$lang[$option.pName]}
					{/if}
					{if $show_count}<span class="count">{$option.Count}</span>{/if}
				</a>
			</li>
		{/strip}{/foreach}
	</ul>
{/if}

<!-- custom field bound boxes end -->