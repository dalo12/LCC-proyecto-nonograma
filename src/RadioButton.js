import React from 'react';

class RadioButton extends React.Component{
   /* constructor(){
        super();
        this.state = {
            //name: React, // ¿qué onda con esto?
            opcion: "#"
        };
        this.onValueChange = this.onValueChange.bind(this);
        //this.formSubmit = this.formSubmit.bind(this);
    }
*/
/*
    onValueChange(event){
        this.setState({
            selectedOption: event.target.value
        });
    }
*/
/*Tengo el presentimiento de que esto no es necesario
    formSubmit(event){
        event.preventDefault();
        console.log(this.state.selectedOption)
    }
 */   
    render(){
        return(
            //<form onSubmit={this.formSubmit}>
            <div>
                <div className="radio">
                    <label>
                        <input
                            type="radio"
                            value="#"
                            checked={this.props.opcion === "#"}
                            onChange={this.props.onChange}
                        />
                        #
                    </label>
                </div>

                <div className="radio">
                    <label>
                        <input
                            type="radio"
                            value="X"
                            checked={this.props.opcion === "X"}
                            onChange={this.props.onChange}
                            //onChange={this.onValueChange}
                        />
                        X
                    </label>
                </div>
            </div>    
            //</form>
           /* <div>
                <form>
                    <input type="radio" id="X" name="opcion" value="X" 
                        onChange={this.state} />
                    <label for="X">X</label>
                    <input type="radio" id="#" name="opcion" value="#" />
                    <label for="#">#</label>
                </form>
            </div>*/
        );
    }
}

export default RadioButton;