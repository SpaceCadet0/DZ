{strip}{php}
global $page_info;

$block = $this -> get_template_vars('block');
$side_bar_exists = $this -> get_template_vars('side_bar_exists');
$class = 'col-md-3 col-sm-4';

if ($page_info['Key'] == 'home') {
	if (in_array($block['Side'], array('middle_left', 'middle_right'))) {
		$class = 'col-md-6 col-sm-4';
	}
} else {
	if ( in_array($block['Side'], array('middle', 'bottom', 'top'))) {
		$class = $side_bar_exists ? 'col-sm-4' : 'col-md-3 col-sm-4';
	} elseif (in_array($block['Side'], array('middle_left', 'middle_right'))) {
		$class = 'col-md-12 col-sm-4';
	}
}

$this -> assign('box_item_class', $class);
{/php}

{rlHook name='featuredItemTop'}

<li {if $featured_listing.ID}id="fli_{$featured_listing.ID}"{/if} class="{$box_item_class}{if !$featured_listing.Main_photo} no-picture{/if}">
	{if $listing_types.$type.Photo}
        <div class="picture">
    		<a title="{$featured_listing.listing_title}" {if $config.featured_new_window}target="_blank"{/if} href="{$featured_listing.url}">
                {if $featured_listing.Main_photo}
                    {if false !== $featured_listing.Main_photo|strpos:$rlTplBase}
                        {assign var='main_photo' value=$featured_listing.Main_photo}
                    {else}
                        {assign var='main_photo' value=$smarty.const.RL_FILES_URL|cat:$featured_listing.Main_photo}
                    {/if}
                {else}
                    {assign var='main_photo' value=$rlTplBase|cat:'img/blank_10x7.gif'}
                {/if}

                <img src="{$main_photo}"
                    {if $featured_listing.Main_photo_x2}srcset="{$smarty.const.RL_FILES_URL}{$featured_listing.Main_photo_x2} 2x"{/if}
                    alt="{$featured_listing.listing_title}" />
                {rlHook name='tplFeaturedItemPhoto'}
    		</a>
        </div>
	{/if}
	
	<ul class="info">
		<li class="title" title="{$featured_listing.fields.title.value|strip_tags}">
			<a {if $config.featured_new_window}target="_blank"{/if} href="{$featured_listing.url}">
				{$featured_listing.fields.title.value}
			</a>
		</li>

		{if $featured_listing.fields.bedrooms.value || $featured_listing.fields.bathrooms.value || $featured_listing.fields.square_feet.value}
			<li class="services">{strip}
				{if $featured_listing.fields.bedrooms.value}
					<span title="{$featured_listing.fields.bedrooms.name}" class="badrooms">{$featured_listing.fields.bedrooms.value}</span>
				{/if}
				{if $featured_listing.fields.bathrooms.value}
					<span title="{$featured_listing.fields.bathrooms.name}" class="bathrooms">{$featured_listing.fields.bathrooms.value}</span>
				{/if}
				{if $featured_listing.fields.square_feet.value}
					<span title="{$featured_listing.fields.square_feet.name}" class="square_feet">{$featured_listing.fields.square_feet.value}</span>
				{/if}
			{/strip}</li>
		{/if}

		<li class="fields">{strip}
			{foreach from=$featured_listing.fields item='item' key='field' name='fieldsF'}
				{if empty($item.value) || !$item.Details_page || ($item.Key == $config.price_tag_field ||$item.Key == 'title' || $item.Key == 'bedrooms' || $item.Key == 'bathrooms' || $item.Key == 'square_feet' || $item.Key == 'time_frame' || ($item.Key == 'sale_rent' && $block.Key|strpos:'ltfb_' === 0))}{continue}{/if}

				<span id="flf_{$featured_listing.ID}_{$item.Key}">{$item.value}</span>
			{/foreach}
		{/strip}</li>

		{if $featured_listing.fields.price.value}
            <li class="price_tag">
                <span>{$featured_listing.fields.price.value}</span>
                {if $featured_listing.sale_rent == 2 && $featured_listing.fields.time_frame.value}
                    &nbsp;/ {$featured_listing.fields.time_frame.value}
                {/if}
            </li>
		{/if}
		{*rlHook name='tplFeaturedItemPrice'*}
	</ul>
</li>

{rlHook name='featuredItemBottom'}

{/strip}
