import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import RadioButton from './RadioButton';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      rowClues: null,
      colClues: null,
      waiting: false,
      opcion: '#',
    };
    this.onValueChange = this.onValueChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
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
    
    const pistas_filas = this.state.rowClues[i];
    const pistas_columnas = this.state.colClues[j];

    const queryS = 'put("' + this.state.opcion + '", [' + i + ',' + j + ']' 
    + ', [' + pistas_filas + '], [' + pistas_columnas +'],' + squaresS + ', GrillaRes, FilaSat, ColSat)';

    console.log(queryS);

    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['GrillaRes'],
          waiting: false
        });

        console.log(response['FilaSat']);
        console.log(response['ColSat']);

      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  /**
   * Manejador de eventos de RadioButton
   * @param {} event Evento capturado
   */
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
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          onClick={(i, j) => this.handleClick(i,j)}
        />
        <div className="gameInfo">
          {statusText}
        </div>
        <div className="selectorOpcion">
          <RadioButton
            value = 'X'
            checked = {this.state.opcion === 'X'}
            onChange = {this.onValueChange}
            contenido = "X"
          />
          <RadioButton
            value = '#'
            checked = {this.state.opcion === '#'}
            onChange = {this.onValueChange}
            contenido = "#"
          />
        </div>
      </div>
    );
  }
}

export default Game;
