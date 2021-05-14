import React from 'react';

class Square extends React.Component {
    render() {
        return (
            <button className={"square" + (this.props.value === "#" ? " relleno" : "")} onClick={this.props.seguir_jugando ? this.props.onClick : null}>
                {(this.props.value === '_' || this.props.value === '#') ? null : this.props.value}
            </button>
        );
    }
}

export default Square;