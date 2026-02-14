extends Node
class_name FluidSolver


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
