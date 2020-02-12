<!-- listing details -->

{if !$errors}

{if $config.map_module && $location.direct}
    {mapsAPI assign='mapAPI'}

    <script>
    rlConfig['mapAPI'] = [];
    rlConfig['mapAPI']['css'] = JSON.parse('{$mapAPI.css|@json_encode}');
    rlConfig['mapAPI']['js']  = JSON.parse('{$mapAPI.js|@json_encode}');
    </script>
{/if}

<div class="listing-details">
	{rlHook name='listingDetailsTopTpl'}

    <section class="main-section{if !$photos} no-picture{/if} clearfix">
		{if $photos}
            <script type="text/javascript">
            var fb_slideshow = {if $config.gallery_slideshow}{literal}{}{/literal}{else}false{/if};
            var fb_slideshow_delay = {if $config.gallery_slideshow_delay}{$config.gallery_slideshow_delay}*1000{else}5000{/if};
            </script>

    		<div class="gallery">
    			<div class="preview{if $photos.0.Type == 'video'} video{/if}">
					<a rel="group" href="{$photos.0.Photo}" title="{if $photos.0.Description}{$photos.0.Description}{else}{$pageInfo.name}{/if}">
						<iframe width="" height="" src="{if $photos.0.Type == 'video'}{if $photos.0.Original == 'youtube'}//www.youtube.com/embed/{$photos.0.Photo}?rel=0{else}{$photos.0.Original}{/if}{/if}" frameborder="0" allowfullscreen></iframe>
                        <video id="player" class="hide" controls>
                            <source src="" type="video/mp4"></source>
                        </video>
						<img title="{if $photos.0.Description}{$photos.0.Description}{else}{$pageInfo.name}{/if}" 
                            src="{if $photos.0.Photo}{$photos.0.Photo}{else}{$rlTplBase}img/blank.gif{/if}" />
                        {rlHook name='tplListingDetailsPhotoPreview'}
						<span class="media-enlarge"><span></span></span>
					</a>

                    {if !$allow_photos}
                        <div id="picture_locked" class="hide">
                            <div>
                                <div class="restricted-content">
                                <img src="{$rlTplBase}img/blank.gif" />
                                {if $isLogin}
                                    <p class="picture-hint hide">{$lang.view_picture_not_available}</p>
                                    <p class="video-hint hide">{$lang.watch_video_not_available}</p>
                                    <span>
                                        <a class="button" title="{$lang.registration}" href="{pageUrl key='my_profile'}#membership">{$lang.change_plan}</a>
                                    </span>
                                {else}
                                    <p class="picture-hint hide">{$lang.view_picture_hint}</p>
                                    <p class="video-hint hide">{$lang.watch_video_hint}</p>
                                    <span>
                                        <a href="javascript://" class="button login">{$lang.sign_in}</a> <span>{$lang.or}</span> <a title="{$lang.registration}" href="{pageUrl key='registration'}">{$lang.sign_up}</a>
                                    </span>
                                {/if}
                                </div>
                            </div>
                        </div>
                    {/if}
    			</div>

    			<div class="thumbs{if $photos|@count == 1} hide{/if}">
    				<div title="{$lang.prev}" class="prev disabled"><div></div></div>
    				<div title="{$lang.next}" class="next"><div></div></div>
    				<div class="slider">
    					<ul>
    						{foreach from=$photos item='photoItem' name='photosF'}{strip}
    						<li class="{if $smarty.foreach.photosF.first}active{/if}{if !$allow_photos && !$smarty.foreach.photosF.first} locked{/if}">
    							<a href="{if $allow_photos || $smarty.foreach.photosF.first}{if $photoItem.Type == 'video'}{if $photoItem.Original == 'youtube'}https://www.youtube.com/watch?v={$photoItem.Photo}{else}{$photoItem.Original}{/if}{else}{$photoItem.Photo}{/if}{else}javascript://{/if}" 
                                   {if $photoItem.Type == 'video'}
                                   accesskey="{if $photoItem.Original == 'youtube'}{$photoItem.Photo}{else}{$photoItem.Original}{/if}" 
                                   target="_blank" class="video {if $photoItem.Original == 'youtube'}youtube{else}local{/if}"
                                   {/if}
                                    >
                                    <img title="{if $photoItem.Description}{$photoItem.Description}{else}{$pageInfo.name}{/if}" 
                                        alt="{if $photoItem.Description}{$photoItem.Description}{else}{$pageInfo.name}{/if}"
                                        src="{if $photoItem.Thumbnail && ($allow_photos || $smarty.foreach.photosF.first)}{$photoItem.Thumbnail}{else}{$rlTplBase}img/blank.gif{/if}" 
                                        {if $photoItem.Thumbnail_x2 && ($allow_photos || $smarty.foreach.photosF.first)}srcset="{$photoItem.Thumbnail_x2} 2x"{/if} />

                                    {if $photoItem.Type == 'video'}<span class="play"></span>{/if}
                                </a>
    						</li>
    						{/strip}{/foreach}
    					</ul>
    				</div>
    			</div>

    			<div id="imgSource" class="hide">
    			{foreach from=$photos item='photo' name='photosF'}
                    {if !$allow_photos && !$smarty.foreach.photosF.first}{continue}{/if}

    				<a rel="group" {if isset($photo.Video)}class="fancybox.iframe" href="//www.youtube.com/embed/{$photo.Preview}?autoplay=1"{else}href="{$photo.Photo}"{/if} title="{if $photo.Description}{$photo.Description}{else}{$pageInfo.name}{/if}"></a>
    			{/foreach}
    			</div>
    		</div>
		{/if}

		<div class="details">
			<div class="top-navigation clearfix">
				<!-- price tag -->
                {if $price_tag_value}
				    <div class="price-tag" id="df_field_price">{$price_tag_value}</div>
				{/if}
				<!-- price tag end -->

				<div class="icons">{strip}
					{if $listing_data.Account_ID == $account_info.ID}
						<a class="button" href="{$rlBase}{if $config.mod_rewrite}{$pages.edit_listing}.html?id={$listing_data.ID}{else}?page={$pages.edit_listing}&amp;id={$listing_data.ID}{/if}">{$lang.edit_listing}</a>
					{else}
						{rlHook name='listingDetailsNavIcons'}

						<a rel="nofollow" target="_blank" href="{$rlBase}{if $config.mod_rewrite}{$pages.print}.html?item=listing&amp;id={$listing_data.ID}{else}?page={$pages.print}&amp;item=listing&amp;id={$listing_data.ID}{/if}" title="{$lang.print_page}" class="print"><span></span></a>
						<span id="fav_{$listing_data.ID}" class="favorite add" title="{$lang.add_to_favorites}"><span></span></span>
					{/if}
				{/strip}</div>
			</div>

			{if $listing_type.Photo && $photos|@count > 0}
				<div class="table-container content-padding">
					{assign var='main_section_break' value=false}
					{assign var='main_section_no_group' value=false}

					{foreach from=$listing item='group'}
						{if $group.Group_ID}
							{if !empty($group.Fields)}
								{if $main_section_no_group}
									{break}
								{/if}

								{foreach from=$group.Fields item='item' key='field' name='fListings'}
									{if !empty($item.value) && $item.Details_page}
										{include file='blocks'|cat:$smarty.const.RL_DS|cat:'field_out.tpl'}
									{/if}
								{/foreach}

								{assign var='main_section_break' value=$group.Key}
							{/if}
						{else}
							{if $group.Fields}
								{foreach from=$group.Fields item='item'}
									{if !empty($item.value) && $item.Details_page}
										{include file='blocks'|cat:$smarty.const.RL_DS|cat:'field_out.tpl'}
									{/if}
								{/foreach}

								{assign var='main_section_no_group' value=true}
							{/if}
						{/if}

						{if $main_section_break}{break}{/if}
					{/foreach}
				</div>
			{/if}

			<div class="plugins-inline">{rlHook name='listingDetailsBeforeStats'}</div>
		</div>
	</section>

	<section class="content-section clearfix">
		<aside class="right">
            {if !$pageInfo.Listing_details_inactive}
                {include file='blocks'|cat:$smarty.const.RL_DS|cat:'listing_details_sidebar.tpl'}
            {/if}

			{strip}
			{foreach from=$blocks item='block'}
			{if $block.Side == 'left'}
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
			{/if}
			{/foreach}
			{/strip}
		</aside>

		<div class="details">
			<!-- tabs -->
            {if $tabs|@count > 1}
			<ul class="tabs tabs-hash">
				{foreach from=$tabs item='tab' name='tabF'}{strip}
					<li {if $smarty.foreach.tabF.first}class="active"{/if} id="tab_{$tab.key}">
                        <a href="#{$tab.key}" data-target="{$tab.key}">{$tab.name}</a>
                    </li>
				{/strip}{/foreach}
			</ul>
            {/if}
			<!-- tabs end -->

			<!-- tabs content -->

			<!-- listing details -->
			<div id="area_listing" class="tab_area">
				{rlHook name='listingDetailsPreFields'}

				<div class="content-padding">
				{foreach from=$listing item='group'}
                    {if ($main_section_no_group && !$group.Key) || (!$main_section_no_group && $group.Key && $group.Key == $main_section_break)}{continue}{/if}

                    <div class="{if $group.Key}{$group.Key}{else}no-group{/if}">
    					{if $group.Group_ID}
    						{assign var='hide' value=false}
    						{if !$group.Display}
    							{assign var='hide' value=true}
    						{/if}
    				
    						{assign var='value_counter' value='0'}
    						{foreach from=$group.Fields item='group_values' name='groupsF'}
    							{if $group_values.value == '' || !$group_values.Details_page}
    								{assign var='value_counter' value=$value_counter+1}
    							{/if}
    						{/foreach}
    				
    						{if !empty($group.Fields) && ($smarty.foreach.groupsF.total != $value_counter)}
    							{include file='blocks'|cat:$smarty.const.RL_DS|cat:'fieldset_header.tpl' id=$group.ID name=$group.name hide=$hide}
    							
                            {if $group.Key == 'location' && $config.map_module && $location.direct}
                                <div class="row">
                                    <div class="col-sm-6 col-xs-12 fields">
    							{foreach from=$group.Fields item='item' key='field' name='fListings'}
    								{if !empty($item.value) && $item.Details_page}
    									{include file='blocks'|cat:$smarty.const.RL_DS|cat:'field_out.tpl'}
    								{/if}
    							{/foreach}
                                    </div>
                                    <div class="col-sm-6 col-xs-12 map">
                                        <section title="{$lang.expand_map}" class="map-capture">
                                            <img alt="{$lang.expand_map}" 
                                                 src="{staticMap location=$location.direct zoom=$config.map_default_zoom width=480 height=180}" 
                                                 srcset="{staticMap location=$location.direct zoom=$config.map_default_zoom width=480 height=180 scale=2} 2x" />
                                            <span class="media-enlarge"><span></span></span>
                                        </section>
                                    </div>
                                </div>

                                {include file='blocks'|cat:$smarty.const.RL_DS|cat:'listing_details_static_map.tpl'}
                            {else}
    							{foreach from=$group.Fields item='item' key='field' name='fListings'}
    								{if !empty($item.value) && $item.Details_page}
    									{include file='blocks'|cat:$smarty.const.RL_DS|cat:'field_out.tpl'}
    								{/if}
    							{/foreach}
                            {/if}
    							
    							{include file='blocks'|cat:$smarty.const.RL_DS|cat:'fieldset_footer.tpl'}
    						{/if}

    						{assign var='main_section_no_group' value=false}
    					{else}
    						{if $group.Fields}
    							{foreach from=$group.Fields item='item'}
    								{if !empty($item.value) && $item.Details_page}
    									{include file='blocks'|cat:$smarty.const.RL_DS|cat:'field_out.tpl'}
    								{/if}
    							{/foreach}
    						{/if}
    					{/if}
                    </div>
				{/foreach}
				</div>

				<!-- statistics area -->
				<section class="side_block statistics clearfix">
					<ul class="controls">
						<li>
							<!-- AddThis Button BEGIN -->
							<div class="addthis_toolbox addthis_default_style addthis_32x32_style">
							<a class="addthis_button_preferred_1"></a>
							<a class="addthis_button_preferred_2"></a>
							<a class="addthis_button_preferred_3"></a>
							<a class="addthis_button_preferred_4"></a>
							<a class="addthis_button_compact"></a>
							<a class="addthis_counter addthis_bubble_style"></a>
							</div>
							<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=xa-52d66a9b40223211"></script>
							<!-- AddThis Button END -->
						</li>
						{rlHook name='listingDetailsAfterStats'}
					</ul>
					<ul class="counters">
						{if $config.count_listing_visits}<li><span class="count">{$listing_data.Shows}</span> {$lang.shows}</li>{/if}
						{if $listing_data.comments_count}<li><a href="#comments"><span class="count">{$listing_data.comments_count}</span> {$lang.comment_tab}</a></li>{/if}
						{rlHook name='listingDetailsCounters'}
					</ul>
				</section>
				<!-- statistics area end -->
			</div>
			<!-- listing details end -->

		{if $config.tell_a_friend_tab}
			<!-- tell a friend tab -->
			<div id="area_tell_friend" class="tab_area hide">
				<div class="content-padding">
					<div class="submit-cell">
						<div class="name">{$lang.friend_name} <span class="red">*</span></div>
						<div class="field"><input class="wauto" type="text" id="friend_name" name="friend_name" maxlength="50" size="30" value="{$smarty.post.friend_name}" /></div>
					</div>

					<div class="submit-cell">
						<div class="name">{$lang.friend_email} <span class="red">*</span></div>
						<div class="field"><input class="wauto" type="text" id="friend_email" name="friend_email" maxlength="50" size="30" value="{$smarty.post.friend_email}" /></div>
					</div>

					<div class="submit-cell">
						<div class="name">{$lang.your_name}</div>
						<div class="field"><input class="wauto" type="text" id="your_name" name="your_name" maxlength="100" size="30" value="{$account_info.Full_name}" /></div>
					</div>

					<div class="submit-cell">
						<div class="name">{$lang.your_email}</div>
						<div class="field"><input class="wauto" type="text" id="your_email" name="your_email" maxlength="30" size="30" value="{$account_info.Mail}" /></div>
					</div>

					<div class="submit-cell">
						<div class="name">{$lang.message}</div>
						<div class="field"><textarea id="message" name="message" rows="6" cols="50">{$smarty.post.message}</textarea></div>
					</div>

					{if $config.security_img_tell_friend}
					<div class="submit-cell">
						<div class="name">{$lang.security_code} <span class="red">*</span></div>
						<div class="field">
							{include file='captcha.tpl' no_caption=true}
						</div>
					</div>
					{/if}

					<div class="submit-cell buttons">
						<div class="name"></div>
						<div class="field"><input onclick="xajax_tellFriend($('#friend_name').val(), $('#friend_email').val(), $('#your_name').val(), $('#your_email').val(), $('#message').val(), $('#security_code').val(), '{$print.id}');$(this).val('{$lang.loading}');" type="button" name="finish" value="{$lang.send}" /></div>
					</div>
				</div>
			</div>
			<!-- tell a friend tab end -->
            {/if}

			{rlHook name='listingDetailsBottomTpl'}

			<!-- tabs content end -->

            <!-- middle blocks area -->
            {if $blocks.middle}
            <aside class="middle">
                {foreach from=$blocks item='block'}
                    {if $block.Side == 'middle'}
                        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
                    {/if}
                {/foreach}
            </aside>
            {/if}
            <!-- middle blocks area end -->
		</div>
	</section>
	
    {if !$allow_photos}
        <div id="picture_locked_mobile" class="hide">
            <div class="tmp-dom">
                <div class="restricted-content">
                {if $isLogin}
                    <p class="picture-hint hide">{$lang.view_picture_not_available}</p>
                    <p class="video-hint hide">{$lang.watch_video_not_available}</p>
                    <span>
                        <a class="button" title="{$lang.registration}" href="{pageUrl key='my_profile'}#membership">{$lang.change_plan}</a>
                    </span>
                {else}
                    <p class="picture-hint hide">{$lang.view_picture_hint}</p>
                    <p class="video-hint hide">{$lang.watch_video_hint}</p>
                    <span>
                        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'login_modal.tpl'}
                    </span>
                {/if}
                </div>
            </div>
        </div>
    {/if}

	<script class="fl-js-dynamic">
	{if isset($smarty.get.highlight)}
		flynaxTpl.highlightResults("{$smarty.session.keyword_search_data.keyword_search}", true);
	{/if}

	var ld_inactive = {if $pageInfo.Listing_details_inactive}'{$lang.ld_inactive_notice}'{else}false{/if};

	{literal}
		if ($('#df_field_vin .value').length > 0) {
			var html = '<a style="font-size: 14px;" href="javascript:void(0);">{/literal}{if $lang.check_vin}{$lang.check_vin}{else}Check Vin{/if}{literal}</a>';
			var vin = trim( $('#df_field_vin .value').text() );
			var frame = '<iframe scrolling="auto" height="600" frameborder="0" width="100%" src="http://www.carfax.com/cfm/check_order.cfm?vin='+vin+'" style="border: 0pt none;overflow-x: hidden; overflow-y: auto;background: white;"></iframe>';
			var source = '';
		}	
	{/literal}
	</script>

	{rlHook name='listingDetailsBottomJs'}

	<script class="fl-js-static">
	{literal}
	$(document).ready(function(){
		if ( ld_inactive ) {
			printMessage('warning', ld_inactive, false, true);
		}
		
        flynaxTpl.picGallery();
        flynaxTpl.setupTextarea('div.seller-short');

        $('.contact-seller').flModal({
            source: '#contact_owner_form',
            width: 400,
            height: 'auto',
            ready: function(){
                flynaxTpl.setupTextarea('div.modal_content');
            }
        });

			$('#df_field_vin .value').append(html);
			
			$('#df_field_vin .value a').flModal({
				content: frame,
				source: source,
				width: 900,
				height: 640
			});
	});
	{/literal}
	</script>

</div>
{else}
	<!-- TODO HERE -->
{/if}

<!-- listing details end -->
