import React, { useState, useEffect } from "react";
import axios from "axios";

import DataTable from 'react-data-table-component';


import "./App.css";


function Bike() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
	const [totalRows, setTotalRows] = useState(100);
	const [perPage, setPerPage] = useState(10);
  const [month, setMonth] = useState(5);
  const [page1, setPage1] = useState(1);
  const [redirState, setState] = useState(false);
  

  

  const fetchData = async (month,perPage,page) => {
		setMonth(month);
    setPage1(page);
    setLoading(true);
    
    
		await axios.get("/bikeRoutes/" +month+ "-" +perPage+"-"+page1).then((res) => {
      setData(res.data);
      
    })
    .catch((err) => console.log(err));;

		
		setLoading(false);
	};
  const loadData = async () => {
		
    setLoading(true);
    
    
		await axios.get("/bikeRoutes/load" ).then((res) => {
      console.log("Loading...");
      
    })
    .catch((err) => console.log(err));;

		
		setLoading(false);
	};
	const handlePageChange = page => {
		if(page < 1) page = 1;
    setLoading(true);
    fetchData(month,perPage,page);
    setLoading(false);
	};

	const handlePerRowsChange = async (newPerPage, page) => {
		setPage1(page);
    setPerPage(newPerPage);
    setLoading(true);

		
		await axios.get("/bikeRoutes/" +month+ "-" +newPerPage+"-"+page1).then((res) => {
      setData(res.data);
      
    })
    .catch((err) => console.log(err));;
		setLoading(false);
	};

  function handleMonthChange(month) {
    
    setLoading(true);
    fetchData(month,perPage,page1);
    setLoading(false);
  }

  const handleButtonClick = (statName) => {
    console.log('clicked');
    console.log(statName);
  
   
    
    };

	useEffect(() => {
		fetchData(month,perPage,page1);
		
	}, []);
  const columns = [
    {
      name: "Departure",
      selector: row => row.departure,
		  sortable: true,
      ignoreRowClick: true,
    },
    {
      name: "return",
      selector: row => row.return,
		  sortable: true,
      ignoreRowClick: false,
      
    },
    {
      name: "Departure station name",
      selector: row => row.depStatName,
		  sortable: true,
      button: true,
      ignoreRowClick: true,
      cell: (row) => <h5 onClick={()=>handleButtonClick(row.retStatName)}>{row.retStatName}</h5>
    
    },
    {
      name: "return station name",
      selector: row => row.retStatName,
		  sortable: true,
      button: true,
      ignoreRowClick: true,
      cell: (row) => <h5 onClick={()=>handleButtonClick(row.retStatName)}>{row.retStatName}</h5>
    },
    {
      name: "distance",
      selector: row => row.distance,
		  sortable: true,
      ignoreRowClick: false,
    },
    {
      name: "duration",
      selector: row => row.duration,
		  sortable: true,
      ignoreRowClick: false,
    }
  ];
  
  return (
    <div className="Bike">
      


      <h1>
        <center>Biking trips</center>
      </h1>
      
      <center><DataTable
			title="Biking trips"
			columns={columns}
			data={data}
			progressPending={loading}
			pagination
			paginationServer
			paginationTotalRows={totalRows}
			
			onChangeRowsPerPage={handlePerRowsChange}
			onChangePage={handlePageChange}

      
		/></center>
    
    <h3>
        <center>Change Month</center>
      </h3>
      <center> <button onClick={() => {
          
          handleMonthChange(5);
        }}> May</button><button onClick={() => {
          
          handleMonthChange(6);
        }}> June</button><button onClick={() => {
          
          handleMonthChange(7);
        }}> July</button></center>

        <center> <button onClick={() => {
          
          loadData();
        }}> Load Data</button></center>
        
    </div>
  );
}

export default Bike;