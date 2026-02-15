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
			var flow = -difference_pressure * delta * flow_per_pressure
			flows.append(flow)
			
			# Sum total flow to know change for next state
			netFlow += flow / 6
		
	#Change in pressure for next state is based on total 'flow'
	
	#TEMP - hjacking this function for testing
	#netFlow = 0
	#netVel
	
	return [netFlow, netVel]


func numpySolver(point: FluidPoint, domain:FluidDomain, delta):
	pass

#u + v vel
func npDiffuse():
	pass

func nvidaSolver(point: FluidPoint, domain:FluidDomain, delta):
	#advection
	var RDX = 1.0
	var a_pos = point.position - point.velocity * delta * RDX
	var advect_vel = a_pos
	#interpolation here
	
	

	
	#jacob??
	#inscrutable equations
	var iterations = 20
	var jacob_vel = advect_vel
	
	#doin this in advance cuz loop
	var neighbors = domain.get_orthogonal_neighbors(point)
	var neighbors_vel = []
	var neighbors_pressure = []
	var neighbors_vel_sum = Vector3.ZERO
	for n in neighbors:
		if n:
			neighbors_vel.append(n.velocity)
			neighbors_vel_sum += n.velocity
			neighbors_pressure.append(n.pressure)
		else:
			neighbors_vel.append(Vector3.ZERO)
			neighbors_pressure.append(0)
	
	#divergence
	var half_rdx = 0.5 / RDX
	var vel_smth = ( (neighbors_vel[1].x - neighbors_vel[0].x ) + 
					(neighbors_vel[3].y - neighbors_vel[2].y ) + 
					(neighbors_vel[5].z - neighbors_vel[4].z ) )
	var divergence = half_rdx * vel_smth
	
	for i in range(iterations):
		var alpha = (jacob_vel * jacob_vel)/delta
		var r_beta = Vector3(1,1,1)/(Vector3(4,4,4)+ (jacob_vel* jacob_vel) /delta)
		#start by checking neighbors
		# -x, x, -y, y, -z, z
		
		var iter = Vector3(0,0,0)
		iter += neighbors_vel_sum
		iter += alpha * jacob_vel
		iter *= divergence
		
		jacob_vel = iter
	
	#force
	#uhhhh
	

	#gradient subtraction
	#neighbors pressure -x, x, -y, y, -z, z
	var new_vel_g = jacob_vel - half_rdx * Vector3(neighbors_pressure[1] - neighbors_pressure[0],
												neighbors_pressure[3] - neighbors_pressure[2],
												neighbors_pressure[5] - neighbors_pressure[4])
	
	return [point.pressure, new_vel_g]
	
	

## Applies changes figured out from self.update()
