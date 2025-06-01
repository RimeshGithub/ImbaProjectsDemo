import Game2048 from "./2048"
import AnalogClock from "./analog_clock"
import AnalogClocks from "./analog_clocks"
import Calculator from "./calculator"
import Calendar from "./calendar"
import Chatbot from "./chatbot"
import CheckerGame from "./checker_game"
import Chess from "./chess"
import ChessAI from "./chess_ai"
import Desmos from "./desmos"
import DifferentiatorIntegrator from "./differentiator_integrator"
import FidgetSpinner from "./fidget_spinner"
import FlappyBird from "./flappy_bird"
import GameOfLife from "./game_of_life"
import GraphCalculator from "./graph_calculator"
import MemoryGame from "./memory_game"
import MusicPlayer from "./music_player"
import Paint from "./paint"
import PhotoEditor from "./photo_editor"
import PythonCompiler from "./python_compiler"
import StickyNotes from "./sticky_notes"
import Sudoku from "./sudoku"
import TicTacToe from "./tictactoe"
import TicTacToeAI from "./tictactoe_ai"

const projects = [
	{name: "2048 Game", id: "Game2048", component: Game2048},
	{name: "Analog Clock", id: "AnalogClock", component: AnalogClock},
	{name: "Analog Clocks", id: "AnalogClocks", component: AnalogClocks},
	{name: "Calculator", id: "Calculator", component: Calculator},
	{name: "Calendar", id: "Calendar", component: Calendar},
	{name: "Chatbot", id: "Chatbot", component: Chatbot},
	{name: "Checker Game", id: "CheckerGame", component: CheckerGame},
	{name: "Chess", id: "Chess", component: Chess},
	{name: "Chess AI", id: "ChessAI", component: ChessAI},
	{name: "Desmos", id: "Desmos", component: Desmos},
	{name: "Differentiator Integrator", id: "DifferentiatorIntegrator", component: DifferentiatorIntegrator},
	{name: "Fidget Spinner", id: "FidgetSpinner", component: FidgetSpinner},
	{name: "Flappy Bird", id: "FlappyBird", component: FlappyBird},
	{name: "Game of Life", id: "GameOfLife", component: GameOfLife},
	{name: "Graph Calculator", id: "GraphCalculator", component: GraphCalculator},
	{name: "Memory Game", id: "MemoryGame", component: MemoryGame},
	{name: "Music Player", id: "MusicPlayer", component: MusicPlayer},
	{name: "Paint", id: "Paint", component: Paint},
	{name: "Photo Editor", id: "PhotoEditor", component: PhotoEditor},
	{name: "Python Compiler", id: "PythonCompiler", component: PythonCompiler},
	{name: "Sticky Notes", id: "StickyNotes", component: StickyNotes},
	{name: "Sudoku", id: "Sudoku", component: Sudoku},
	{name: "Tic Tac Toe", id: "TicTacToe", component: TicTacToe},
	{name: "Tic Tac Toe AI", id: "TicTacToeAI", component: TicTacToeAI},
]

tag Router
	def render
		<self>
			<div route="/">
				<MainMenu>
			for project in projects
				<div route="/{project.id}">
					<{project.component}>
			<div route="/*" [pos:fixed inset:0 d:vflex ja:center ai:center]>
				<h1> "404 - Page Not Found"
				<a route-to="/" [mt:20 p:10 bg:#f0f0f0 rd:5 cursor:pointer td:none]> "Back to Menu"

tag MainMenu
	css d:flex ja:center inset:0

	def render
		<self>
			<div [w:600px p:40px bg:linear-gradient(135deg,#f0f9ff,#e0f7fa) rd:50px 
			box-shadow:0 4px 20px rgba(0,0,0,0.2) d:vflex ja:center g:20px]>
				<h1 [fs:24px c:#333 ff:sans-serif fw:bold]> "Imba Project Hub"
				<div [border:4px solid white rd:12px]>
					<div [d:grid g:15px grid-template-columns:repeat(2, 200px) column-gap:30px h:400px ofy:auto p:20px]>
						for project in projects
							<a route-to="/{project.id}"
							[bg:#fff rd:10px cursor:pointer box-shadow:0 2px 5px rgba(0,0,0,0.1) td:none d:flex ja:center ta:center
							fs:16px c:#444 ff:monospace fw:bold bg@active:#f5f5f5 h:90px outline:none]>
								project.name

# Mount the router instead of main-menu directly
imba.mount <Router>