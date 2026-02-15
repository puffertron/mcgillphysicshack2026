extends Node
class_name FluidEquations


const GRAVITY: float = 9.8

#navier stokes
# section 1
# fluid_density * ( delta_vel + velocity *  (delta_field / delta_vel.x delta_field / delta_vel.y) 
#section 2
# - (delta_pressure / delta
# Force = pressure gradient + body forces (gravity) + spreadoutieness
func check_scalar_gradient(point: Vector3i) -> Vector3:
	var gradient: Vector3
	return gradient
	
func check_vector_gradient(point: Vector3i) -> Vector3:
	var gradient: Vector3
	return gradient

func update_cell(cell: FluidPoint) -> Vector3:
	var pressure_grad = -check_scalar_gradient(cell.position)
	var body_force = cell.density * GRAVITY
	var diffusion = cell.viscosity * check_vector_gradient(cell.velocity)
	var force = pressure_grad + body_force + diffusion
	return force
	
func ciaranPropogation(domain, pressure, point, delta):
	var netVel = Vector3(0,0,0)
	# Get neighbors
	var neighbors: Array[FluidPoint] = domain.get_orthogonal_neighbors(point)
	
	const flow_per_pressure = 0.5 #arbitrary constant representing how quick flow happens per change in pressure
	# Calc pressure difference between each neighbor
	var difference_pressure
	var difference_pressures = []
	var flows = []
	var netFlow = 0
	for i in range(6):
		if neighbors[i] == null:
			pass
		else:
			var incoming_pressure = neighbors[i].pressure
			difference_pressure = pressure - incoming_pressure
			difference_pressures.append(difference_pressure)
		
			# Calc flow between each neighbor
			var flow = difference_pressure * delta * flow_per_pressure
			flows.append(flow)
			
			# Sum total flow to know change for next state
			netFlow += flow / 6
		
	#Change in pressure for next state is based on total 'flow'
	return [netFlow, netVel]

func nvidaSolver(point, domain, velocity, pressure, delta):
	
	
	

## Applies changes figured out from self.update()
