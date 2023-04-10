window.onload = function () {
    document.querySelectorAll('.toggle_all_inside_table_body')
        .forEach(item => item.addEventListener('click', toggleCheckboxInsideTableBody));
};

function toggleCheckboxInsideTableBody() {
    const parentTable = this.closest('table');
    const checkboxes = parentTable.querySelectorAll('tr td input[type=checkbox]');
    checkboxes.forEach(checkbox => checkbox.checked = this.checked);
}