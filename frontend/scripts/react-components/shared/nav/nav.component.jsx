import React from 'react';
import PropTypes from 'prop-types';
import cx from 'classnames';
import throttle from 'lodash/throttle';
import NavLinksList from 'react-components/shared/nav-links-list.component';

const links = [
  {
    name: 'Supply Chain',
    page: 'tool'
  },
  {
    name: 'Map',
    page: 'tool'
  },
  {
    name: 'Profiles',
    page: 'profiles'
  },
  {
    name: 'Download',
    page: 'data'
  },
  {
    name: 'About',
    page: 'about'
  }
];

class Nav extends React.PureComponent {
  static getDownloadPdfLink() {
    const pageTitle = encodeURIComponent(document.getElementsByTagName('title')[0].innerText);
    const currentUrlBase = NODE_ENV_DEV
      ? document.location.href.replace('localhost:8081', 'staging.trase.earth')
      : document.location.href;
    const currentUrl = encodeURIComponent(`${currentUrlBase}&print=true`);
    return `${PDF_DOWNLOAD_URL}?filename=${pageTitle}&url=${currentUrl}`;
  }

  constructor(props) {
    super(props);
    this.state = {
      backgroundVisible: false
    };

    this.setBackground = throttle(this.setBackground.bind(this), 300);
    window.addEventListener('scroll', this.setBackground);
  }

  componentWillUnmount() {
    this.setBackground.cancel();
    window.removeEventListener('scroll', this.setBackground);
  }

  setBackground() {
    const { pageOffset } = this.props;
    const { backgroundVisible } = this.state;
    const hasOffset = typeof pageOffset !== 'undefined';
    if (hasOffset && window.pageYOffset > pageOffset && !backgroundVisible) {
      this.setState({ backgroundVisible: true });
    } else if (hasOffset && window.pageYOffset <= pageOffset && backgroundVisible) {
      this.setState({ backgroundVisible: false });
    }
  }

  render() {
    const { className, printable } = this.props;
    const { backgroundVisible } = this.state;
    return (
      <div className={cx('c-nav', { '-has-background': backgroundVisible }, className)}>
        <div className="row align-justify">
          <div className="column medium-7">
            <NavLinksList
              links={links}
              listClassName="nav-item-list"
              itemClassName="nav-item"
              linkClassName="nav-link"
              linkActiveClassName="nav-link -active"
            />
          </div>
          <div className="column medium-2">
            {printable &&
              <ul className="nav-item-list">
                <li className="nav-item">
                  <a href={Nav.getDownloadPdfLink()} target="_blank" rel="noopener noreferrer">
                    <svg className="icon icon-download-pdf">
                      <use xlinkHref="#icon-download-pdf" />
                    </svg>
                  </a>
                </li>
              </ul>
            }
          </div>
        </div>
      </div>
    );
  }
}

Nav.propTypes = {
  className: PropTypes.string,
  pageOffset: PropTypes.number,
  printable: PropTypes.bool
};

Nav.defaultProps = {
  pageOffset: 0
};

export default Nav;
