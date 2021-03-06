import { connect } from 'react-redux';
import { toggleDropdown } from 'actions/app.actions';
import { selectYears } from 'actions/tool.actions';
import YearsSelector from 'react-components/nav/filters-nav/years-selector/years-selector.component';

const mapStateToProps = state => ({
  currentDropdown: state.app.currentDropdown,
  selectedYears: state.tool.selectedYears,
  years: state.tool.selectedContext.years
});

const mapDispatchToProps = dispatch => ({
  onToggle: id => {
    dispatch(toggleDropdown(id));
  },
  onSelected: years => {
    dispatch(selectYears(years));
  }
});

export default connect(mapStateToProps, mapDispatchToProps)(YearsSelector);
