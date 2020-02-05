<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/dist/Chart.min.js"></script>
	<script src="${pageContext.request.contextPath}/dist/utils.js"></script>
	<script type="text/javascript"src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.3/xlsx.full.min.js"></script>
	
	<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
	<style>
	canvas {
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}
	</style>
</head>
<body>
<div id="container" style="width: 40%;">
		<canvas id="canvas1"></canvas>
	</div>
	 Excel File Upload<input type="file" id="fileUpload" accept=".xls,.xlsx" /><br />
    <button type="button" id="uploadExcel">Convert</button>
    <pre id="jsonData"></pre>
    CSV file Uplaod<input type="file" id="csvfile" accept=".csv" /><br />
    <pre id="jsonDatacsv"></pre>
    <button type="button" id="convertcsv">Convert</button>
    <button type="button" id="Drawchart">Chartdraw</button>
    <script>
    var selectedFile;
    var colums;
    var colums_types=[];
    var csvfile;
    var csvdata;
    var excel_data=[];
    document.getElementById("fileUpload").addEventListener("change", function(event) {
        selectedFile = event.target.files[0];
      });
    document.getElementById("uploadExcel").addEventListener("click", function() {
        if (selectedFile) {
          var fileReader = new FileReader();
          fileReader.onload = function(event) {
            var data = event.target.result;

            var workbook = XLSX.read(data, {
              type: "binary"
            });
            var i=0;
            workbook.SheetNames.forEach(sheet => {
              let rowObject = XLSX.utils.sheet_to_row_object_array(
                workbook.Sheets[sheet]
              );
             	colums=Object.keys(rowObject[i]);
             	console.log(colums);
             	
             	for(let elem in rowObject[i]) {  
             		excel_data.push(rowObject[i][elem]);
              	}
             	console.log(excel_data);
             	for(let elem in rowObject[i]) {  
            	  colums_types.push(typeof rowObject[i][elem]);
            	}
              i++;
            });
          };
          fileReader.readAsBinaryString(selectedFile);
        }
        
        console.log(colums_types);
      });
    
    
    
    var fileInput = document.getElementById("csvfile"),

    readFile = function () {
        var reader = new FileReader();
        reader.onload = function () {
            console.log(csvJSON(reader.result));
        };
        // start reading the file. When it is done, calls the onload event defined above.
        reader.readAsBinaryString(fileInput.files[0]);
    };

	fileInput.addEventListener('change', readFile);

   document.getElementById("convertcsv").addEventListener("click", function() {
	   
   });
    function csvJSON(csv){

    	  var lines=csv.split("\n");

    	  var result = [];

    	  var headers=lines[0].split(",");

    	  for(var i=1;i<lines.length;i++){
			
    		  var obj = {};
    		  var currentline=lines[i].split(",");

    		  for(var j=0;j<headers.length;j++){
    			  obj[headers[j]] = currentline[j];
    		  }

    		  result.push(obj);

    	  }
    	  
    	  //return result; //JavaScript object
    	  return result; //JSON
    	}

  </script>
<script>
$(document).ready(function() {
	  $("#Drawchart").on("click", function() {
		  console.log("fired");
		  var color = Chart.helpers.color;
			var barChartData = {
				labels: colums,
				datasets: [{
					label: 'Dataset 1',
					backgroundColor: color(window.chartColors.red).alpha(0.5).rgbString(),
					borderColor: window.chartColors.red,
					borderWidth: 2,
					data: excel_data
				}
			]

			};

			
				var ctx = document.getElementById('canvas1').getContext('2d');
				window.myBar = new Chart(ctx, {
					type: 'bar',
					data: barChartData,
					options: {
						responsive: true,
						legend: {
							position: 'top',
						},
						title: {
							display: true,
							text: 'Chart.js Bar Chart'
						}
					}
				});

			

	  });
	});

		
	</script>
	<!-- <div style="width:75%;">
		<canvas id="canvas2"></canvas>
	</div>
	<script>
		var config = {
			type: 'line',
			data: {
				labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
				datasets: [{
					label: 'My First dataset',
					backgroundColor: window.chartColors.red,
					borderColor: window.chartColors.red,
					data: [10, 30, 50, 20, 25, 44, -10],
					fill: false,
				}, {
					label: 'My Second dataset',
					fill: false,
					backgroundColor: window.chartColors.blue,
					borderColor: window.chartColors.blue,
					data: [100, 33, 22, 19, 11, 49, 30],
				}]
			},
			options: {
				responsive: true,
				title: {
					display: true,
					text: 'Min and Max Settings'
				},
				scales: {
					yAxes: [{
						ticks: {
							min: 10,
							max: 50
						}
					}]
				}
			}
		};

		window.onload = function() {
			var ctx1 = document.getElementById('canvas2').getContext('2d');
			window.myLine = new Chart(ctx1, config);
		};
	</script>
		  -->
</body>
</html>