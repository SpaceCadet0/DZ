<!-- listing item -->

{rlHook name='listingTop'}

{if $listing.Listing_type}
	{assign var='listing_type' value=$listing_types[$listing.Listing_type]}
{/if}

<article class="item{if $listing.Featured} featured{/if}{if !$listing_type.Photo} no-image{/if} col-sm-4{if !$side_bar_exists} col-md-3{/if} {rlHook name='tplListingItemClass'}">
	<div class="main-column">
		{if $listing_type.Photo}
			<a title="{$listing.listing_title}" {if $config.view_details_new_window}target="_blank"{/if} href="{$listing.url}">
				<div class="picture{if !$listing.Main_photo} no-picture{/if}">
                    <img src="{if $listing.Main_photo}{$smarty.const.RL_FILES_URL}{$listing.Main_photo}{else}{$rlTplBase}img/blank_10x7.gif{/if}"
                        {if $listing.Main_photo_x2}srcset="{$smarty.const.RL_FILES_URL}{$listing.Main_photo_x2} 2x"{/if}
                        alt="{$listing.listing_title}" />
                    {rlHook name='tplListingItemPhoto'}
					{if $listing.Featured}<div class="label"><div title="{$lang.featured}">{$lang.featured}</div></div>{/if}
					{if !empty($listing.Main_photo) && $config.grid_photos_count}
						<span accesskey="{$listing.Photos_count}"></span>
					{/if}
				</div>
			</a>
		{/if}

		{if $listing.fields[$config.price_tag_field].value}
			<div class="price-tag{if $listing.sale_rent == 2} rent{/if}">
				<span>{$listing.fields[$config.price_tag_field].value}</span>
				{if $listing.sale_rent == 2 && $listing.fields.time_frame.value}
                    / {$listing.fields.time_frame.value}
                {/if}
			</div>
		{/if}
		
		<ul class="nav-column{if !$listing.fields[$config.price_tag_field].value} stick-top{/if}">
			<li id="fav_{$listing.ID}" class="favorite add" title="{$lang.add_to_favorites}"><span class="icon"></span><span class="link">{$lang.add_to_favorites}</span></li>
			{rlHook name='listingNavIcons'}
		</ul>
		
		<ul class="info clearfix{if $config.sf_display_fields} with-names{/if}">
			<li class="title">
				<a class="link-large" 
                    title="{$listing.listing_title}" 
                    {if $config.view_details_new_window}target="_blank"{/if} 
                    href="{$listing.url}">
                    {$listing.listing_title}
                </a>
			</li>
			{if $listing.fields.bedrooms.value || $listing.fields.bathrooms.value || $listing.fields.square_feet.value}
				<li class="services">{strip}
					{if $listing.fields.bedrooms.value}
						<span title="{$listing.fields.bedrooms.name}" class="badrooms">{$listing.fields.bedrooms.value}</span>
					{/if}
					{if $listing.fields.bathrooms.value}
						<span title="{$listing.fields.bathrooms.name}" class="bathrooms">{$listing.fields.bathrooms.value}</span>
					{/if}
					{if $listing.fields.square_feet.value}
						<span title="{$listing.fields.square_feet.name}" class="square_feet">{$listing.fields.square_feet.value}</span>
					{/if}
				{/strip}</li>
			{/if}
			<li class="middle">
				{rlHook name='listingBeforeStats'}
			</li>
			<li class="fields">
				{assign var='f_first' value=true}
				{foreach from=$listing.fields item='item' key='field' name='fListings'}
					{if empty($item.value) || !$item.Details_page || ($item.Key == $config.price_tag_field || $item.Key|in_array:$tpl_settings.listing_grid_except_fields)}{continue}{/if}

					{if $config.sf_display_fields}
						<div class="table-cell small clearfix">
							<div class="name">{$item.name}</div>
							<div class="value">{$item.value}</div>
						</div>
					{else}
						<span>{$item.value}</span>
					{/if}
				{/foreach}
				
				{rlHook name='listingAfterFields'}
			</li>
			<li class="system">
				{if $config.display_posted_date}<span class="date">{$listing.Date|date_format:$smarty.const.RL_DATE_FORMAT}</span>{/if}
				
				{rlHook name='listingAfterStats'}
			</li>
		</ul>
	</div>

	<span class="category-info hide">
        <a href="{$rlBase}{if $config.mod_rewrite}{$pages[$listing_type.Page_key]}/{$listing.Path}{if $listing_type.Cat_postfix}.html{else}/{/if}{else}?page={$pages[$listing_type.Page_key]}&amp;category={$listing.Category_ID}{/if}">
            {$listing.name}
        </a>
	</span>
</article>

<!-- listing item end -->
