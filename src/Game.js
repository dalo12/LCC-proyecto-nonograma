import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import RadioButton from './RadioButton';

class Game extends React.Component {

  pengine;
  variable;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      waiting: false,
      opcion: 'X',
      pistas_filas: null,
      pistas_columnas: null,
    };
    this.onValueChange = this.onValueChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumnas, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          pistas_filas: response['PistasFilas'],
          pistas_columnas: response['PistasColumnas']
        });
      }
    });
  }

  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', "_"); // Remove quotes for variables.
    const queryS = 'put("'+ this.state.opcion +'", [' + i + ',' + j + ']' 
    + ', [], [],' + squaresS + ', GrillaRes, FilaSat, ColSat)';
    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['GrillaRes'],
          waiting: false
        });
      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  onValueChange(event){
    this.setState({
        opcion: event.target.value
    });
  }

  render() {
    if (this.state.grid === null) {
      return null;
    }

    const statusText = 'Keep playing!';
    return (
      <div className="game">
        <Board
          grid={this.state.grid}
          onClick={(i, j) => this.handleClick(i,j)}
          pistas_filas = {this.state.pistas_filas}
          pistas_columnas = {this.state.pistas_columnas}
        />
        <div className="gameInfo">
          {statusText}
        </div>
        <div>
          <RadioButton 
            value= 'X'
            checked={this.state.opcion === 'X'}
            onChange={this.onValueChange}
            contenido = "X"
          />
          <RadioButton
            value= '#'
            checked={this.state.opcion === '#'}
            onChange={this.onValueChange}
            contenido = "#"
          />
        </div>
      </div>
    );
  }
}

export default Game;
