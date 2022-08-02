import React, { useState, useEffect } from "react";
import axios from "axios";

import DataTable from 'react-data-table-component';


import "./App.css";


function App() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
	const [totalRows, setTotalRows] = useState(100);
	const [perPage, setPerPage] = useState(10);
  const [month, setMonth] = useState(5);
  const [page1, setPage1] = useState(1);
  
  

  

  const fetchUsers = async (month,perPage,page) => {
		setLoading(true);
    setPage1(page);
    setMonth(month);
		await axios.get("/bikeRoutes/" +month+ "-" +perPage+"-"+page1).then((res) => {
      setData(res.data);
      
    })
    .catch((err) => console.log(err));;

		
		setLoading(false);
	};

	const handlePageChange = page => {
		setLoading(true);
    fetchUsers(month,perPage,page);
    setLoading(false);
	};

	const handlePerRowsChange = async (newPerPage, page) => {
		setLoading(true);

		setPage1(page);
    setPerPage(newPerPage);
		fetchUsers(month,perPage,page);
		setLoading(false);
	};

	useEffect(() => {
		fetchUsers(5,10,1);
		
	}, []);
  const columns = [
    {
      name: "Departure",
      selector: row => row.departure,
		  sortable: true
    },
    {
      name: "return",
      selector: row => row.return,
		  sortable: true
    },
    {
      name: "Departure station name",
      selector: row => row.depStatName,
		  sortable: true
    },
    {
      name: "return station name",
      selector: row => row.retStatName,
		  sortable: true
    },
    {
      name: "distance",
      selector: row => row.distance,
		  sortable: true
    },
    {
      name: "duration",
      selector: row => row.duration,
		  sortable: true
    }
  ];

  return (
    <div className="App">
      <h1>
        <center>React Table Demo</center>
      </h1>
      
      <DataTable
			title="Biking trips"
			columns={columns}
			data={data}
			progressPending={loading}
			pagination
			paginationServer
			paginationTotalRows={totalRows}
			selectableRows
			onChangeRowsPerPage={handlePerRowsChange}
			onChangePage={handlePageChange}
		/>
    </div>
  );
}

export default App;