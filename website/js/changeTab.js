function changeTab(page) {
	
	var alltabz = document.getElementById("tabz").getElementsByTagName("li");

	var currentpage = document.getElementById(page);

	if (page == "plots") {
		document.getElementById("plots-div").style.display = "block";
		document.getElementById("table-div").style.display = "none";
	}
	else {
		document.getElementById("plots-div").style.display = "none";
		document.getElementById("table-div").style.display = "block";
	}

	for (var i = 0; i < alltabz.length; i++) {
		alltabz[i].classList.remove("active");

	}

	currentpage.classList.add("active");


}

