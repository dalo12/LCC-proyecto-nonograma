import React from 'react'

class Tip extends React.Component{
    render(){
        return(
            <button className="tip" disabled> {this.props.contenido} </button>
        );
        // el valor de this.props.contenido viene de 'Board.js'
    }
}

export default Tip;