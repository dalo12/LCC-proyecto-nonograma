import React from 'react';
import Square from './Square';
import Tip from './Tip'

class Board extends React.Component {
    render() {
        const numOfRows = this.props.grid.length;
        const numOfCols = this.props.grid[0].length;

        /* para mostrar las pistas */
        const numOfRowsTips = numOfRows + 1;
        const numOfColsTips = numOfCols + 1;
        const items = [];
        let pista = "";

        for(let i=0; i<numOfRowsTips; i++){
            for(let j=0; j<numOfColsTips; j++){

                if(i === 0 && j === 0){
                    items.push(<Tip key={0} contenido = "" />)
                }else{
                    if(i === 0){
                        /* 
                        para que muestre las pistas bien formateadas
                        por ejemplo, si la pista [1, 2], no muestre "12" sino "1 \n 2"
                        */
                        pista = "";
                        this.props.pistas_columnas[j-1].forEach(e => {
                            pista += e + " ";
                        });
                        // items.push(<Tip key={j} contenido = {this.props.pistas_columnas[j-1]}/>)
                        items.push(<Tip key={j} contenido = {pista}/>)
                    }else if(j === 0){
                        /* 
                        para que muestre las pistas bien formateadas
                        por ejemplo, si la pista [1, 2], no muestre "12" sino "1 \n 2"
                        */
                        pista = "";
                        this.props.pistas_filas[i-1].forEach(e => {
                            pista += e + " ";
                        });
                        items.push(<Tip key={i} contenido = {pista} />)
                    }else{
                        items.push(
                            <Square 
                                value = {this.props.grid[i-1][j-1]}
                                onClick = {() => this.props.onClick(i-1, j-1)}
                                key={i + j}
                            />)
                    }
                }
            }
        }

        return (
            <div className="board" 
                 style={{
                    gridTemplateRows: 'repeat(' + numOfRowsTips + ', 40px)',
                    gridTemplateColumns: 'repeat(' + numOfColsTips + ', 40px)'
                 }}>
                {
                    items
                /* Esto es lo original que nos dió la cátedra
                this.props.grid.map((row, i) =>
                    row.map((cell, j) =>
                        <Square
                            value={cell}
                            onClick={() => this.props.onClick(i, j)}
                            key={i + j}
                        />
                    )
                )
                */
                }
            </div>
        );
    }
}

export default Board;