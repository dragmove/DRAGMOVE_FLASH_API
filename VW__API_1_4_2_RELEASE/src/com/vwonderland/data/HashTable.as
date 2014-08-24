/**
 * The MIT License
 *
 * Copyright (c) 2010 VW
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.vwonderland.data
{
	/**
	 * HashTable class
	 * @example Basic usage:
	 * <listing version="3.0">
	var hashTable:HashTable = new HashTable("id", "name", "add", "email"); // id, name, add, email 열을 갖는 HashTable을 생성합니다.
	trace(hashTable.printTable()); // uniqueIndex | rowIndex     | id                 | name             | add               | email           |   
	 * </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	dynamic public class HashTable extends Object
	{
		private var _rowArray:Array;
		private var _columnArray:Array;
		private var _uniqueIndex:int;
		
		/**
		 * 행과 열을 갖는 테이블 구조의 HashTable 생성 (해당 구현은 HashMap의 확장된 형태이며, 행과 열의 순서를 일정하게 유지하는 것을 보증합니다)
		 * @param _columns
		 */
		public function HashTable(... _columns) {
			_uniqueIndex = 0;
			_rowArray = new Array();
			_columnArray = new Array();
			var key:String;
			for each(key in _columns){
				_columnArray.push(key);
			}
		}
		
		/**
		 * 지정된 열 값을 테이블에 입력
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.printTable());
		// uniqueIndex | rowIndex     | id                 | name             | add               | email           |  
		// 0                   | 0                   | molgga         | 이윤석               | 인천                 | 메일주소1           |  
		// 1                   | 1                   | nohong7       | 노홍철               | 서울                 | 메일주소2           |  
		 * </listing>
		 * @param _values
		 */
		public function putColumns(... _values):void {
			var columnHash:HashMap = new HashMap();
			var key:String;
			for(var i:uint = 0; i < _columnArray.length; i++){
				columnHash.put(_columnArray[i], _values[i]);
			}
			_rowArray.push(_uniqueIndex);
			this[_uniqueIndex++] = columnHash;
		}
		
		/**
		 * 지정된 rowIndex에 해당하는 행의 HashMap 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.getRow(0)); // [object HashMap] // 해당 HashMap은 HashTable 생성시 등록한 id, name, add, email의 키 값을 가지고 있게 됩니다.
		 * </listing>
		 * @param rowIndex
		 * @return HashMap
		 */
		public function getRow(_rowIndex:int):HashMap {
			if(this[_rowArray[_rowIndex]] == null){
				trace("[com.vwonderland.data.HashTable] Error HashTable getRow out of index. return null");
				return null;
			}
			return this[_rowArray[_rowIndex]] as HashMap;
		}
		
		/**
		 * 지정된 rowIndex에 해당하는 행의 key값에 맵핑된 값 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.getColumn(0, "name"));  // 이윤석
		 * </listing>
		 * @param _rowIndex
		 * @param _key
		 * @return 
		 */
		public function getColumn(_rowIndex:int, _key:String):Object {
			if(this[_rowArray[_rowIndex]] == null){
				trace("[com.vwonderland.data.HashTable] Error HashTable getColumn out of index. return null");
				return null;
			}
			return this[_rowArray[_rowIndex]][_key];
		}
		
		/**
		 * 지정된 key에 해당하는 모든 Column의 값을 배열에 담아 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id" , "name" , "add" , "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.getColumns("id"));  // molgga,nohong7
		 * </listing>
		 * @param _key
		 * @return Array
		 */
		public function getColumns(_key:String):Array {
			var columnArray:Array = new Array();
			var row:String;
			for(row in this){
				columnArray.push(this[row][_key]);
			}
			return columnArray;
		}
		
		/**
		 * 지정된 rowIndex에 해당하는 행의 삭제
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.printTable(10));
		// uniqueIndex | rowIndex     | id                 | name             | add               | email           |  
		// 0                   | 0                   | molgga         | 이윤석               | 인천                 | 메일주소1           |  
		// 1                   | 1                   | nohong7       | 노홍철               | 서울                 | 메일주소2           |  
		
		hashTable.removeRows(0);
		trace(hashTable.printTable(10));
		// uniqueIndex | rowIndex     | id                 | name             | add               | email           |  
		// 1                   | 0                   | nohong7       | 노홍철               | 서울                 | 메일주소2           |  
		 * </listing>
		 * @param _rowIndex
		 */
		public function removeRows(_rowIndex:int):void {
			try{
				delete this[_rowArray[_rowIndex]];
				_rowArray.splice(_rowIndex, 1);
			}catch(e:Error){
				trace("[com.vwonderland.data.HashTable] Error HashTable removeRows out of index");
			}
		}
		
		/**
		 * 지정된 key에 해당하는 열의 삭제
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.printTable(10));
		// uniqueIndex | rowIndex     | id                 | name             | add               | email           |  
		// 0                   | 0                   | molgga         | 이윤석               | 인천                 | 메일주소1           |  
		// 1                   | 1                   | nohong7       | 노홍철               | 서울                 | 메일주소2           |  
		
		hashTable.removeColumns("name");
		trace(hashTable.printTable(10));
		// uniqueIndex | rowIndex     | id                 | add               | email           |  
		// 0                   | 0                   | molgga         | 인천                 | 메일주소1           |  
		// 1                   | 1                   | nohong7       | 서울                 | 메일주소2           | 
		 * </listing>
		 * @param _key
		 */
		public function removeColumns(_key:String):void {
			var row:String;
			var hashMap:HashMap;
			for(row in this){
				hashMap = this[row] as HashMap;
				hashMap.remove(_key);
			}
			var spliceIndex:int = -9;
			for(var i:uint = 0; i < _columnArray.length; i++){
				if(_columnArray[i] == _key){
					spliceIndex = i;
					break;
				}
			}
			if(spliceIndex != -9) _columnArray.splice(spliceIndex, 1);
		}
		
		/**
		 * HashTable의 맵핑된 모든 데이터 삭제
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.size);  // 2
		
		hashTable.clear();
		trace(hashTable.size);  // 0
	 	 * </listing>
		 */
		public function clear():void {
			var row:String;
			for(row in this){
				this[row].clear();
				delete this[row];
			}
			_rowArray = null;
		}
		
		/**
		 * HashTable의 맵핑된 행의 수 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		trace(hashTable.size);  // 0
		
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		trace(hashTable.size);  // 1
	 	 * </listing>
		 * @return int
		 */
		public function get size():int {
			var cnt:int = 0;
			var key:String;
			for(key in this) cnt++;
			return cnt;
		}
		
		/**
		 * HashTable에 맵핑된 데이터가 존재하지 않는지의 확인(맵핑된 데이터가 없다면 true 반환)
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		trace(hashTable.isEmpty());  // true
		
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		trace(hashTable.isEmpty());  // false
		
		hashTable.clear();
		trace(hashTable.isEmpty());  // true
		 * </listing>
		 * @return Boolean
		 */
		public function isEmpty():Boolean {
			var key:String;
			for(key in this){
				return false;
			}
			return true;
		}
		
		/**
		 * HashTable에 맵핑된 행과 열을 나열하여 문자열로 반환(지정된 stringTempLength 값에 의해 문자열의 공백을 채우며, 이는 HashTable의 현재 맵핑 상태를 쉽게 볼 수 있도록 도와줍니다)
		 * @example Basic usage:
		 * <listing version="3.0">
		var hashTable:HashTable = new HashTable("id", "name", "add", "email");
		hashTable.putColumns("molgga", "이윤석", "인천", "메일주소1");
		hashTable.putColumns("nohong7", "노홍철", "서울", "메일주소2");
		trace(hashTable.printTable(10));
		// uniqueIndex | rowIndex     | id                 | name             | add               | email           |  
		// 0                   | 0                   | molgga         | 이윤석               | 인천                 | 메일주소1           |  
        // 1                   | 1                   | nohong7       | 노홍철               | 서울                 | 메일주소2           |  
		trace(hashTable.printTable(20));
		// uniqueIndex                   | rowIndex                         | id                                     | name                                 | add                                   | email                               |  
		// 0                                       | 0                                       | molgga                             | 이윤석                                   | 인천                                     | 메일주소1                               |  
        // 1                                       | 1                                       | nohong7                           | 노홍철                                   | 서울                                     | 메일주소2                               |  
		 * </listing>
		 * @param _stringTempLength
		 * @return String
		 */
		public function printTable(_stringTempLength:int=10):String {
			var stackTrace:String = "";
			var columnKey:String;
			var columnValue:String;
			var columnHash:HashMap;
			var row:String;
			var rowCnt:int = 0;
			stackTrace = stackTrace.concat("uniqueIndex", this.emptyString(String("uniqueIndex").length, _stringTempLength) , " | "); 
			stackTrace = stackTrace.concat("rowIndex", this.emptyString(String("rowIndex").length, _stringTempLength) , " | "); 
			for(var i:uint = 0; i < _columnArray.length; i++){
				columnKey = _columnArray[i];
				stackTrace = stackTrace.concat(columnKey , this.emptyString(columnKey.length, _stringTempLength) , " | ");
			}
			stackTrace = stackTrace.concat("\n");
			for(row in this){
				columnHash = this[row] as HashMap;
				if(columnHash != null){
					stackTrace = stackTrace.concat(row, this.emptyString(String(row).length, _stringTempLength) , " | ");
					stackTrace = stackTrace.concat(rowCnt, this.emptyString(String(rowCnt).length, _stringTempLength) , " | ");
					for(var column:uint = 0 ; column < columnHash.size  ; column++){
						columnValue = String(columnHash.getValue(_columnArray[column]));
						stackTrace = stackTrace.concat(columnValue , this.emptyString(columnValue.length , _stringTempLength) , " | ");
					}
					stackTrace = stackTrace.concat("\n");
					rowCnt++;
				}
			}
			return stackTrace;
		}
		private function emptyString(_val:int, _len:int):String {
			var tempStr:String = "";
			for(var i:uint = _val; i < _len; i++){
				tempStr = tempStr.concat("  ");
			}
			return tempStr;
		}
	}
}