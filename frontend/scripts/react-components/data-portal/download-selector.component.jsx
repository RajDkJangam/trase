/* eslint-disable jsx-a11y/no-static-element-interactions */
import 'styles/components/profiles/chord.scss';
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';
import includes from 'lodash/includes';

class DownloadSelector extends Component {
  renderOptions() {
    return this.props.options.map((elem, key) => (
      <li key={key}>
        <span>{elem.name}</span>
        <div
          className={classnames(
            'c-radio-btn',
            '-red',
            { '-no-self-cancel': elem.noSelfCancel },
            { '-enabled': includes(this.props.selected, elem.id) }
          )}
          onClick={() => this.props.onOptionSelected(this.props.type, elem.id)}
        />
      </li>
    ));
  }

  render() {
    return (
      <div
        className={classnames('c-custom-dataset-selector', { '-disabled': !this.props.enabled })}
        data-type="value"
      >
        <div className="c-custom-dataset-selector__header">
          {this.props.title}
          {this.props.allowMultiple && (
            <ul className="c-custom-dataset-selector__header-options">
              <li>
                <div
                  className={classnames('c-radio-btn', '-red', {
                    '-enabled': this.props.allSelected
                  })}
                  onClick={() => this.props.onAllSelected(this.props.type)}
                />
              </li>
            </ul>
          )}
        </div>
        <span className="c-custom-dataset-selector__disabled-text">{this.props.disabledText}</span>
        <ul className="c-custom-dataset-selector__values">{this.renderOptions()}</ul>
      </div>
    );
  }
}

DownloadSelector.defaultProps = {
  options: []
};

DownloadSelector.propTypes = {
  allSelected: PropTypes.bool,
  allowMultiple: PropTypes.bool,
  disabledText: PropTypes.string,
  enabled: PropTypes.bool,
  selected: PropTypes.array,
  options: PropTypes.array,
  onOptionSelected: PropTypes.func.isRequired,
  onAllSelected: PropTypes.func,
  title: PropTypes.string,
  type: PropTypes.string
};

export default DownloadSelector;
