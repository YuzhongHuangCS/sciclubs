<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Portal extends CI_Model {

	public function __construct()
	{
		parent::__construct();
		$this->load->database('slave');
	}

	/**
	 * Retrive all info
	 *
	 * This method is quite costy, need cache
	 * @return  array
	 */
	public function query()
	{
		$data = array();
		$category = array();

		$sql = 'SELECT `ID`, `name`, `info` FROM `category`';
		$_sql = 'SELECT `name` FROM `category_field` WHERE `categoryID` = ? ORDER BY `rank` ASC';

		foreach ($this->db->query($sql)->result_array() as $index => $row) {
			$ID = $row['ID'];
			unset($row['ID']);

			$field = array();
			foreach ($this->db->query($_sql, $ID)->result_array() as $_index => $_row) {
				$field[] = $_row['name'];
			}
			$row['field'] = $field;
			$category[$ID] = $row;
		}
		$data['category'] = $category;

		$group = array();
		$sql = 'SELECT `categoryID`, `name`, `rank` FROM `category_keyword`';

		foreach ($this->db->query($sql)->result_array() as $index => $row) {
			if(!isset($group[$row['rank']])) {
				$group[$row['rank']] = array();
			}

			if(!isset($group[$row['rank']][$row['name']])) {
				$group[$row['rank']][$row['name']] = array();
			}

			$group[$row['rank']][$row['name']][] = $row['categoryID'];
		}

		$data['group'] = array_values($group);
		return $data;
	}

}