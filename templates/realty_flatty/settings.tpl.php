<?php

/******************************************************************************
 *  
 *  PROJECT: Flynax Classifieds Software
 *  VERSION: 4.8.0
 *  LICENSE: RU9018RLF896 - https://www.flynax.ru/user-agreement.html
 *  PRODUCT: Real Estate Classifieds
 *  DOMAIN: domozhil.ru
 *  FILE: INDEX.PHP
 *  
 *  The software is a commercial product delivered under single, non-exclusive,
 *  non-transferable license for one domain or IP address. Therefore distribution,
 *  sale or transfer of the file in whole or in part without permission of Flynax
 *  respective owners is considered to be illegal and breach of Flynax License End
 *  User Agreement.
 *  
 *  You are not allowed to remove this information from the file without permission
 *  of Flynax respective owners.
 *  
 *  Flynax Classifieds Software 2020 | All copyrights reserved.
 *  
 *  https://www.flynax.ru
 ******************************************************************************/

/* template settings */
$tpl_settings = array(
	'type' => 'responsive_42', // DO NOT CHANGE THIS SETTING
	'version' => 2.0,
	'name' => 'realty_flatty',
	'inventory_menu' => false,
	'right_block' => false,
	'long_top_block' => false,
	'featured_price_tag' => true,
	'ffb_list' => false, //field bound boxes plugins list
	'fbb_custom_tpl' => true,
	'header_banner' => true,
    'header_banner_size_hint' => '468x60',
    'home_page_gallery' => true,
    'search_on_map_page' => true,
	'home_page_map_search' => false,
	'browse_add_listing_icon' => true,
	'listing_grid_except_fields' => array('title', 'bedrooms', 'bathrooms', 'square_feet', 'time_frame', 'phone'),
    'sidebar_sticky_pages' => array('listing_details'),
    'sidebar_restricted_pages' => array('home'),
    'qtip' => array(
        'background' => '4b4b4b',
        'b_color'    => '4b4b4b',
    ),
);

if ( is_object($rlSmarty) ) {
	$rlSmarty -> assign_by_ref('tpl_settings', $tpl_settings);
}